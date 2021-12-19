package Engine::Workflow::Action::Salesorder::Close;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::Exception qw( workflow_error );

use Engine::Model::Salesorder::Head;
use Minion;

sub execute ($self, $wf) {

    my $pg = $self->get_pg();

    my $context = $wf->context;
    my $result = $self->close (
        $context->param('companies_fkey'), $context->param('users_fkey'), $context
    );

    return $result;
}

sub close ($self, $companies_pkey, $users_pkey, $context){

    my $log = Log::Log4perl->get_logger();
    my $db = $self->get_pg->db;
    my $tx = $db->begin();

    my $salesorder_statistics = qq{
        INSERT INTO salesorder_statistics (salesorders_fkey, stockitem, customers_fkey,
            users_fkey, companies_fkey, orderdate, deliverydate, quantity, price, customer_addresses_fkey)
        SELECT salesorders_pkey, stockitem, customers_fkey,
            users_fkey, companies_fkey, orderdate, salesorder_items.deliverydate, quantity, price, customer_addresses_fkey
                FROM salesorders JOIN salesorder_items ON salesorders_pkey = salesorders_fkey
                    where salesorders_pkey = ?
    };

    my $err;
    eval {

        Engine::Model::Salesorder::Head->new(
            db => $db
        )->close(
            $companies_pkey, $users_pkey, $context->param('salesorders_pkey')
        );

        $db->query($salesorder_statistics,($context->param('salesorders_pkey')));
        $tx->commit();

    };
    $err = $@ if $@;
    $log->error(
        "Engine::Action::Salesorder::Close close " . $err
    ) if $err;

    my $result->{minion} = 'create_invoice_from_salesorder';
    $result->{salesorders_pkey} = $context->param('salesorders_pkey');
    $result->{companies_pkey} = $companies_pkey;
    $result->{users_pkey} = $users_pkey;

    return $result;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'SalesordersPersister' )->get_pg();
}
1;