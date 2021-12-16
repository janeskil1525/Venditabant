package Engine::Helpers::Salesorder::Processor::Close;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::Exception qw( workflow_error );

use Engine::Model::Salesorder::Head;

sub execute ($self, $wf) {

    my $pg = $self->get_pg();

    my $context = $wf->context;
    $self->close ($context->param('companies_fkey'), $context->param('users_fkey'), $context)
}

sub close ($self, $companies_pkey, $users_pkey, $data){

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
        my $customer_addresses = await venditabant::Helpers::Customers::Address->new(
            pg => $self->pg
        )->load_delivery_address_p(
            $companies_pkey, $users_pkey, $data->{customer_addresses_fkey}
        );

        my $customers_fkey = $customer_addresses->{customers_fkey};
        my $salesorders_pkey = await venditabant::Model::Salesorder::Head->new(
            db => $db
        )->close(
            $companies_pkey, $users_pkey, $customers_fkey
        );

        $db->query($salesorder_statistics,($salesorders_pkey));
        $tx->commit();
        my $minion->{salesorders_pkey} = $salesorders_pkey;
        $minion->{customers_fkey} = $customers_fkey;
        $minion->{companies_fkey} = $companies_pkey;
        $minion->{users_pkey} = $users_pkey;

        $self->minion->enqueue(
            'create_invoice_from_salesorder' => [$minion] => {
                priority => 0,
            }
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Salesorder::Salesorders', 'close', $err
    ) if $err;

    return $err ? $err : 'success';
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'SalesordersPersister' )->get_pg();
}
1;