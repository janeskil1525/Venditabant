package venditabant;
use Mojo::Base 'Mojolicious', -signatures, -async_await;;

use Mojo::Pg;

use venditabant::Helpers::Login;
use venditabant::Helpers::Stockitems;
use venditabant::Helpers::Jwt;
use venditabant::Helpers::Pricelists;
use venditabant::Helpers::Customers::Customers;
use venditabant::Helpers::Users;
use venditabant::Helpers::Salesorder::Salesorders;
use venditabant::Helpers::Companies::Release::Release;
use venditabant::Helpers::Sentinel::Sentinelsender;
use venditabant::Helpers::Parameter::Parameters;
use venditabant::Helpers::Customers::Address;
use venditabant::Helpers::Companies::Company;
use venditabant::Helpers::Sentinel::Sentinel;
use venditabant::Helpers::Parameter::Languages;
use venditabant::Helpers::Mailer::Templates::Mailtemplates;
use venditabant::Helpers::Warehouses::Warehouse;

use Data::Dumper;
use File::Share;
use Mojo::File;

use Mojo::JSON qw {from_json};

$ENV{VENDITABANT_HOME} = '/home/jan/Project/Venditabant/Backend/venditabant/'
    unless $ENV{VENDITABANT_HOME};

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
        state $salesorders = venditabant::Helpers::Salesorder::Salesorders->new(pg => shift->pg)
      }
  );
  $self->helper(
      customers => sub {
    state  $customers = venditabant::Helpers::Customers::Customers->new(pg => shift->pg)
  });
  $self->helper(
      parameters => sub {
        state  $parameters= venditabant::Helpers::Parameter::Parameters->new(pg => shift->pg)
      });
  $self->helper(
      customeraddress => sub {
        state  $customeraddress = venditabant::Helpers::Customers::Address->new(pg => shift->pg)
      });

  $self->helper(
      companies => sub {
        state  $companies = venditabant::Helpers::Companies::Company->new(pg => shift->pg)
      });

  $self->helper(
      sentinel => sub {
        state  $sentinel = venditabant::Helpers::Sentinel::Sentinel->new(pg => shift->pg)
      });
  $self->helper(
      languages => sub {
        state  $languages = venditabant::Helpers::Parameter::Languages->new(pg => shift->pg)
      });

    $self->helper(
        mailtemplates => sub {
            state  $mailtemplates = venditabant::Helpers::Mailer::Templates::Mailtemplates->new(pg => shift->pg)
        });

  $self->helper(
      warehouses => sub {
        state  $warehouses = venditabant::Helpers::Warehouses::Warehouse->new(pg => shift->pg)
      });

  # Configure the application
  $self->secrets($config->{secrets});
  $self->log->path($self->home() . $self->config('log'));

  $self->pg->migrations->name('venditabant')->from_file(
      $self->dist_dir->child('migrations/venditabant.sql')
  )->migrate(26);

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
      '/pricelists/items/load_list/:pricelists_fkey'
  )->to(
      'pricelists#load_list_items'
  );
  $auth->put('/customers/save/')->to('customers#save_customer');
  $auth->get('/customers/load_list/')->to('customers#load_list');
  $auth->put('/customers/invoice/address/save/')->to('customeraddresses#save_address');
  $auth->get('/customers/invoice/address/load/:customers_fkey')->to('customeraddresses#load_invoice_address');

  $auth->put('/customers/delivery/address/save/')->to('customeraddresses#save_address');
  $auth->get('/customers/delivery/address/load/:customer_addresses_pkey')->to('customeraddresses#load_delivery_address');
  $auth->get('/customers/delivery/address/load_list/:customers_fkey')->to('customeraddresses#load_delivery_address_list');

  $auth->put('/users/save/')->to('users#save_user');
  $auth->get('/users/load_list/')->to('users#load_list');
  $auth->get('/users/load_list/support/')->to('users#load_list_support');

  $auth->put('/salesorders/save/')->to('salesorders#save_salesorder');
  $auth->put('/salesorders/close/')->to('salesorders#close_salesorder');
  $auth->get('/salesorders/load_salesorder_list/:open')->to('salesorders#load_salesorder_list');
  $auth->get('/salesorders/load_salesorder/:salesorders_pkey')->to('salesorders#load_salesorder');
  $auth->get('/salesorders/items/load_list/:salesorders_fkey')->to('salesorders#load_salesorder_items_list');
  $auth->put('/salesorders/items/save/')->to('salesorders#item_save');

  $auth->get('/parameters/load_list/:parameter')->to('parameters#load_list');
  $auth->put('/parameters/save/')->to('parameters#save_parameter');
  $auth->put('/parameters/delete/')->to('parameters#delete_parameter');

  $auth->get('/company/load/')->to('companies#load');
  $auth->get('/company/load_list/')->to('companies#load_list');
  $auth->put('/company/save/')->to('companies#save_company');

  $auth->get('/sentinel/load_list/')->to('sentinel#load_list');

  $auth->get('/languages/load_list/')->to('languages#load_list');

  $auth->get('/mailtemplates/load_mailer_list/')->to('mailtemplates#load_mailer_list');
  $auth->get('/mailtemplates/load_list/:mailer_fkey')->to('mailtemplates#load_list');
  $auth->put('/mailtemplates/save/')->to('mailtemplates#save_template');

  $auth->get('/warehouses/load_list/')->to('warehouses#load_list');
  $auth->put('/warehouses/save/')->to('warehouses#save_warehouse');

}

1;
