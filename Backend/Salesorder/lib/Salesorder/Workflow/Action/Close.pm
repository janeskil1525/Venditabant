package Salesorder::Workflow::Action::Close;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );

use Salesorder::Model::Head;

sub execute ($self, $wf) {

    #my $pg = $self->get_pg();

    my $context = $wf->context;
    my $result = $self->close (
        $context->param('companies_fkey'), $context->param('users_fkey'), $context
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "Close order",
            description => "Order with key $context->param('salesorders_pkey') closed",
            user        => $context->param('history')->{userid},
        })
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

        Salesorder::Model::Head->new(
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

    my $result->{activity} = 'create_invoice_from_salesorder, process_invoice';
    $result->{type} = 'workflow';
    $result->{payload}->{salesorders_pkey} = $context->param('salesorders_pkey');
    $result->{payload}->{companies_pkey} = $companies_pkey;
    $result->{payload}->{users_pkey} = $users_pkey;
    $result->{users_pkey} = $users_pkey;
    $result->{companies_pkey} = $companies_pkey;

    return $result;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'SalesordersPersister' )->get_pg();
}
1;