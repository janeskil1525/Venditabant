package venditabant;
use Mojo::Base 'Mojolicious', -signatures, -async_await;;

use Mojo::Pg;

use venditabant::Helpers::Login;
use venditabant::Helpers::Stockitems;
use venditabant::Helpers::Jwt;
use venditabant::Helpers::Pricelists;
use venditabant::Helpers::Customers;
use venditabant::Helpers::Users;
use venditabant::Helpers::Salesorders;
use venditabant::Helpers::Companies::Release::Release;
use venditabant::Helpers::Sentinel::Sentinelsender;

use Data::Dumper;
use File::Share;
use Mojo::File;

use Mojo::JSON qw {from_json};

$ENV{VENDITABANT_HOME} = '/home/jan/Project/Venditabant/Backend/venditabant/'
    unless $ENV{TRANSLATIONS_HOME};

has dist_dir => sub {
  return Mojo::File->new(
      File::Share::dist_dir('venditabant')
  );
};

has home => sub {
  Mojo::Home->new($ENV{VENDITABANT_HOME});
};

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('Config');
  $self->helper(pg => sub {state $pg = Mojo::Pg->new->dsn(shift->config('pg'))});
  $self->helper(users => sub {
    state $users = venditabant::Helpers::Users->new(pg => $self->pg);
  });
  $self->helper(login => sub {state $login = venditabant::Helpers::Login->new(pg => shift->pg)});
  $self->helper(stockitems => sub {state $stockitems = venditabant::Helpers::Stockitems->new(pg => shift->pg)});
  $self->helper(jwt => sub {state $jwt = venditabant::Helpers::Jwt->new()});
  $self->helper(pricelists => sub {state $pricelists = venditabant::Helpers::Pricelists->new(pg => shift->pg)});
  $self->helper(
      salesorders => sub {
        state $salesorders = venditabant::Helpers::Salesorders->new(pg => shift->pg)
      }
  );

  $self->helper(
      customers => sub {
    state  $customers = venditabant::Helpers::Customers->new(pg => shift->pg)
  });


  # Configure the application
  $self->secrets($config->{secrets});
  $self->log->path($self->home() . $self->config('log'));

  $self->pg->migrations->name('venditabant')->from_file(
      $self->dist_dir->child('migrations/venditabant.sql')
  )->migrate(15);

  $self->renderer->paths([
      $self->dist_dir->child('templates'),
  ]);
  $self->static->paths([
      $self->dist_dir->child('public'),
  ]);

  venditabant::Helpers::Companies::Release::Release->new(
      db => $self->pg->db,
      pg => $self->pg,
  )->release()->catch(sub ($err) {
    venditabant::Helpers::Sentinel::Sentinelsender->new(
    )->capture_message(
        $self->pg,'','venditabant 11', 'startup', $err
    );
  })->wait;

  # Normal route to controller
  my $r = $self->routes;

  my $auth = $r->under('/api/v1' => sub {
    my $c = shift;
    #say "authentichate " . $c->req->headers->header('X-Token-Check');
    # Authenticated

    return 1 if $c->login->authenticate($c->req->headers->header('X-Token-Check'));
    # Not authenticated
    $c->render(json => '{"error":"unknown error"}');
    return undef;
  });

  $r->get('/')->to('Example#welcome');


  $r->put('/api/login/')->to('login#login_user');
  $r->put('/api/signup/')->to('signup#signup_company');

  $auth->put('/stockitem/save/')->to('stockitems#save_stockitem');
  $auth->get('/stockitem/load_list/')->to('stockitems#load_list');
  $auth->get('/stockitem/load_list/mobile/:customer')->to('stockitems#load_list_mobile');
  $auth->get('/stockitem/load_list/mobile/')->to('stockitems#load_list_mobile_nocust');

  $auth->get('/pricelists/heads/load_list/')->to('pricelists#load_list_heads');
  $auth->put('/pricelists/heads/save/')->to('pricelists#upsert_head');
  $auth->put('/pricelists/items/save/')->to('pricelists#insert_item');
  $auth->get(
      '/pricelists/items/load_list/:pricelist'
  )->to(
      'pricelists#load_list_items'
  );
  $auth->put('/customers/save/')->to('customers#save_customer');
  $auth->get('/customers/load_list/')->to('customers#load_list');
  $auth->put('/users/save/')->to('users#save_user');
  $auth->get('/users/load_list/')->to('users#load_list');
  $auth->get('/users/load_list/support/')->to('users#load_list_support');

  $auth->put('/salesorders/save/')->to('salesorders#save_salesorder');
  $auth->put('/salesorders/close/')->to('salesorders#close_salesorder');
  $auth->get('/salesorders/load_list/')->to('salesorders#load_list');
}

1;
