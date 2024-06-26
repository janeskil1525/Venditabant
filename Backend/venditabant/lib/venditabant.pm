package venditabant;
use Mojo::Base 'Mojolicious', -signatures, -async_await;

use Mojo::Pg;

use venditabant::Helpers::Login;
use System::Helpers::Jwt;
use Pricelists;
use Customers;
use Stockitems;
use Release;
use Companies;
use CheckPoints::Helpers::Autotodos;
use venditabant::Helpers::Users;
use venditabant::Helpers::Salesorder::Salesorders;
use Sentinel::Helpers::Sentinelsender;
use venditabant::Helpers::Parameter::Parameters;
use Sentinel::Helpers::Sentinel;
use venditabant::Helpers::Parameter::Languages;
# use venditabant::Helpers::Mailer::Templates::Mailtemplates;
use venditabant::Helpers::Warehouses::Warehouse;
use CheckPoints::Helpers::Autotodos;
use venditabant::Helpers::Invoice::Invoices;
use System::Helpers::Settings;
use Currencies;
use venditabant::Helpers::Stockitems::Mobilelist;
use venditabant::Helpers::Minion;
use venditabant::Helpers::History::History;
use Workflows;
#use Pgroutes;

use Data::Dumper;
use File::Share;
use Mojo::File;

use Mojo::JSON qw {from_json};

$ENV{VENDITABANT_HOME} = '/home/jan/IdeaProjects/Venditabant/Backend/venditabant/'
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
    $self->plugin('Minion'  => { Pg => $self->pg });

    $self->helper(users => sub {
        state $users = venditabant::Helpers::Users->new(pg => $self->pg);
    });
    $self->helper(login => sub {state $login = venditabant::Helpers::Login->new(pg => shift->pg)});

    $self->helper(jwt => sub {state $jwt = System::Helpers::Jwt->new()});

    $self->helper(
      parameters => sub {
        state  $parameters = venditabant::Helpers::Parameter::Parameters->new(pg => shift->pg)
      });

    $self->helper(
      companies => sub {
        state  $companies = Companies->new(pg => shift->pg)
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

    $self->helper(
      autotodos => sub {
        state  $autotodos = CheckPoints::Helpers::Autotodos->new(pg => shift->pg)
      });
    $self->helper(
     invoices => sub {
         state  $invoices = venditabant::Helpers::Invoice::Invoices->new(pg => shift->pg)
      });
    $self->helper(
      systemsettings => sub {
        state  $systemsettings = System::Helpers::Settings->new(pg => shift->pg)
      });
    $self->helper(
      currencies => sub {
        state  $currencies = Currencies->new(pg => shift->pg)
      });
    $self->helper(
      mobilelist => sub {
        state  $mobilelist = venditabant::Helpers::Stockitems::Mobilelist->new(pg => shift->pg)
      });
    $self->helper(
      minioninit => sub {
        state  $minioninit = venditabant::Helpers::Minion->new(pg => shift->pg)
      });
    $self->minioninit->init($self->minion);

    $self->helper(
      workflows => sub {
        state  $workflows = Workflows->new(pg => shift->pg)
      });

    $self->helper(
        history => sub {
            state  $history = venditabant::Helpers::History::History->new(pg => shift->pg)
        });

    # Configure the application
    $self->secrets($config->{secrets});
    $self->log->path($self->home() . $self->config('log'));
    $self->log->level($self->config('loglevel'));

    $self->pg->migrations->name('venditabant')->from_file(
      $self->dist_dir->child('migrations/venditabant.sql')
    )->migrate(54);

    $self->renderer->paths([
      $self->dist_dir->child('templates'),
    ]);
    $self->static->paths([
      $self->dist_dir->child('public'),
    ]);

    Release->new(
      pg => $self->pg,
    )->release()->catch(sub ($err) {
        Sentinel::Helpers::Sentinelsender->new(
        )->capture_message(
            $self->pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
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
    my $schema = from_json(Mojo::File->new(
        $self->dist_dir->child('schema/translations.json')
    )->slurp) ;

    # $self->plugin(
    #     'Yancy' => {
    #         route       => $auth,
    #         backend     => {Pg => $self->pg},
    #         schema      => $schema,
    #         read_schema => 0,
    #         'editor.return_to'   => '/app/menu/show/',
    #         'editor.require_user' => undef,
    #         file => {
    #
    #         }
    #     }
    # );

    $self->plugin('Workflow', {route => $auth} );
    $self->plugin('Pgroutes', {route => $auth} );

    $r->get('/')->to('Example#welcome');

    $r->put('/api/login/')->to('login#login_user');
    $r->put('/api/signup/')->to('signup#signup_company');

    # $self->workflow->init($auth);
    # $auth->put('/stockitem/save/')->to('stockitems#save_stockitem');
    # $auth->get('/stockitem/load_list/')->to('stockitems#load_list');
    #
    # $auth->get('/mobilelist/load_list/:customers_fkey/:customer_addresses_pkey')->to('mobilelist#load_list_mobile');
    # $auth->get('/mobilelist/load_list/')->to('mobilelist#load_list_mobile_nocust');
    #
    # $auth->get('/pricelists/heads/load_list/')->to('pricelists#load_list_heads');
    # $auth->put('/pricelists/heads/save/')->to('pricelists#upsert_head');
    # $auth->put('/pricelists/items/save/')->to('pricelists#insert_item');
    # $auth->get(
    #   '/pricelists/items/load_list/:pricelists_fkey'
    # )->to(
    #   'pricelists#load_list_items'
    # );
    # $auth->put('/customers/save/')->to('customers#save_customer');
    # $auth->get('/customers/load_list/')->to('customers#load_list');
    # $auth->get('/customers/deliveryaddresses/load_list/')->to('customers#load_deliveryaddrs_list');
    # $auth->put('/customers/invoice/address/save/')->to('customeraddresses#save_address');
    # $auth->get('/customers/invoice/address/load/:customers_fkey')->to('customeraddresses#load_invoice_address');

    # $auth->put('/customers/delivery/address/save/')->to('customeraddresses#save_address');
    # $auth->get(
    #     '/customers/delivery/address/load/:customer_addresses_pkey'
    # )->to(
    #     'customeraddresses#load_delivery_address'
    # );
    # $auth->get(
    #     '/customers/delivery/address/loadfromname/:customers_fkey/:name'
    # )->to(
    #     'customeraddresses#load_delivery_address_fromname'
    # );
    # $auth->get('/customers/delivery/address/load_list/:customers_fkey')->to('customeraddresses#load_delivery_address_list');
    # $auth->get('/customers/delivery/address/load_list_customer/:customer')->to('customeraddresses#load_delivery_address_from_customer_list');
    # $auth->get('/customers/delivery/address/load_list_company/')->to('customeraddresses#load_delivery_address_from_company_list');
    #
    #
    # $auth->put('/users/save/')->to('users#save_user');
    # $auth->get('/users/load_list/')->to('users#load_list');
    # $auth->get('/users/load_list/support/')->to('users#load_list_support');
    #
    # $auth->put('/salesorders/save/')->to('salesorders#save_salesorder');
    # $auth->put('/salesorders/close/')->to('salesorders#close_salesorder');
    # $auth->get('/salesorders/load_key/:customer_addresses_pkey')->to('salesorders#load_salesorder_pkey');
    # $auth->get('/salesorders/load_salesorder_list/:open')->to('salesorders#load_salesorder_list');
    # $auth->get('/salesorders/load_salesorder/:salesorders_pkey')->to('salesorders#load_salesorder');
    # $auth->get('/salesorders/items/load_list/:salesorders_fkey')->to('salesorders#load_salesorder_items_list');
    # $auth->put('/salesorders/items/save/')->to('salesorders#item_save');
    # $auth->put('/salesorders/items/save_item/')->to('salesorders#save_item');
    #
    #
    # $auth->get('/parameters/load_list/:parameter')->to('parameters#load_list');
    # $auth->put('/parameters/save/')->to('parameters#save_parameter');
    # $auth->put('/parameters/delete/')->to('parameters#delete_parameter');
    #
    # $auth->get('/company/load/')->to('companies#load');
    # $auth->get('/company/load_list/')->to('companies#load_list');
    # $auth->put('/company/save/')->to('companies#save_company');
    #
    # $auth->get('/sentinel/load_list/')->to('sentinel#load_list');
    #
    # $auth->get('/languages/load_list/')->to('languages#load_list');
    #
    # $auth->get('/mailtemplates/load_mailer_list/')->to('mailtemplates#load_mailer_list');
    # $auth->get('/mailtemplates/load_list/:mailer_fkey')->to('mailtemplates#load_list');
    # $auth->put('/mailtemplates/save/')->to('mailtemplates#save_template');
    #
    # $auth->get('/warehouses/load_list/')->to('warehouses#load_list');
    # $auth->put('/warehouses/save/')->to('warehouses#save_warehouse');
    #
    # $auth->get('/autotodos/load_list/')->to('autotodos#load_list');
    # $auth->put('/autotodos/save/')->to('autotodos#save_warehouse');
    # $auth->get('/autotodos/run_checkpoints/')->to('autotodos#run_checkpoints');
    #
    # $auth->put('/invoices/save/')->to('invoices#save_salesorder');
    # $auth->put('/invoices/close/')->to('invoices#close_salesorder');
    # $auth->get('/invoices/load_invoice_list/:open')->to('invoices#load_invoice_list');
    # $auth->get('/invoices/load_invoice/:invoice_fkey')->to('invoices#load_invoice');
    # $auth->get('/invoices/items/load_list/:invoice_fkey')->to('invoices#load_invoice_items_list');
    # $auth->put('/invoices/items/save/')->to('invoices#item_save');
    #
    # $auth->get('/systemsettings/load/:setting')->to('systemsettings#load');
    # $auth->put('/systemsettings/save/')->to('systemsettings#save_system_parameter');
    #
    # $auth->get('/currencies/load_list/')->to('currencies#load_list');
    #
    # $auth->get('/discounts/stockitems/load_list/:customers_fkey')->to('discounts#load_list_stockitem_discount');
    # $auth->put('/discounts/stockitems/save/')->to('discounts#save_stockitem_discount');
    # $auth->get('/discounts/productgroups/load_list/:customers_fkey')->to('discounts#load_list_productgroups_discount');
    # $auth->put('/discounts/productgroups/save/')->to('discounts#save_productgroups_discount');
    # $auth->get('/discounts/general/load_list/:customers_fkey')->to('discounts#load_list_general_discount');
    # $auth->put('/discounts/general/save/')->to('discounts#save_general_discount');
    # $auth->get('/discounts/general/delete/:customer_discount_pkey/:customers_fkey')->to('discounts#delete_general_discount');


}

1;
