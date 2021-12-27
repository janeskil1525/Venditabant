package Engine::Helpers::Salesorder::Salesorders;
use Mojo::Base -base, -signatures, -async_await;

use Engine::Model::Salesorder::Head;
use Engine::Model::Salesorder::Item;
use Engine::Model::Counter;
use Engine::Helpers::Customers::Address;
use Engine::Model::Stockitems;
use Engine::Helpers::Salesorder::PrepareItem;

use Data::Dumper;

has 'pg';
has 'minion';

sub load_salesorder_full($self, $companies_pkey, $users_pkey, $salesorders_fkey) {
    my $log = Log::Log4perl->get_logger();

    my $order;
    eval {
        $order->{salesorder} = await $self->load_salesorder(
            $companies_pkey, $users_pkey, $salesorders_fkey
        );
        $order->{items} = await $self->load_salesorder_items_list(
            $companies_pkey, $users_pkey, $salesorders_fkey
        );
        $order->{invaddress} = await Engine::Helpers::Customers::Address->new(
            pg => $self->pg
        )->load_invoice_address_p(
            $companies_pkey, $users_pkey, $order->{salesorder}->{customers_fkey}
        );

    };
    $log->error(
        "Engine::HelpersSalesorder::Salesorders load_salesorder_full peky = $salesorders_fkey " . $@
    ) if $@;

    return $order;
}

async sub load_salesorder_items_list ($self, $companies_pkey, $users_pkey, $salesorders_fkey) {

    my $result;
    my $err;
    eval {
        $result = await Engine::Model::Salesorder::Item->new(
            db => $self->pg->db
        )->load_items_list (
            $companies_pkey, $users_pkey, $salesorders_fkey
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Salesorder::Salesorders', 'load_list_p', $err
    ) if $err;

    return $result;
}

async sub load_salesorder($self, $companies_pkey, $users_pkey, $salesorders_pkey) {
    my $result;
    my $err;
    eval {
        $result = await Engine::Model::Salesorder::Head->new(
            db => $self->pg->db
        )->load_salesorder (
            $companies_pkey, $users_pkey, $salesorders_pkey
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Salesorder::Salesorders', 'load_salesorder', $err
    ) if $err;

    return $result;
}

1;