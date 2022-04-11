package venditabant::Helpers::Salesorder::Salesorders;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Salesorder::Head;
use venditabant::Model::Salesorder::Item;
use venditabant::Model::Counter;
use Customers;
use venditabant::Model::Stockitems;

use Data::Dumper;

has 'pg';

async sub load_salesorder_full($self, $companies_pkey, $users_pkey, $salesorders_fkey) {

    my $order;
    my $err;
    eval {
        $order->{salesorder} = await $self->load_salesorder(
            $companies_pkey, $users_pkey, $salesorders_fkey
        );
        $order->{items} = await $self->load_salesorder_items_list(
            $companies_pkey, $users_pkey, $salesorders_fkey
        );
        $order->{invaddress} = await venditabant::Helpers::Customers::Address->new(
            pg => $self->pg
        )->load_invoice_address_p(
            $companies_pkey, $users_pkey, $order->{salesorder}->{customers_fkey}
        );

    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Salesorder::Salesorders', 'load_list_p', $err
    ) if $err;

    return $order;
}

async sub load_salesorder_items_list ($self, $companies_pkey, $users_pkey, $salesorders_fkey) {

    my $result;
    my $err;
    eval {
        $result = await venditabant::Model::Salesorder::Item->new(
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
        $result = await venditabant::Model::Salesorder::Head->new(
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

async sub load_salesorder_list ($self, $companies_pkey, $users_pkey, $data) {

    my $result;
    my $err;
    eval {
        $result = venditabant::Model::Salesorder::Head->new(
            db => $self->pg->db
        )->load_salesorder_list (
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Salesorder::Salesorders', 'load_list_p', $err
    ) if $err;

    return $result;
}

async sub imvoice ($self, $companies_pkey, $users_pkey, $salesorders_pkey) {

    $self->db->update('salesorders',
        {
            invoiced => 'true'
        },
        {
            salesorders_pkey => $salesorders_pkey
        }
    );
}

sub get_open_so_pkey($self, $companies_pkey, $users_pkey, $customer_addresses_pkey) {

    my $stmt = qq {
            SELECT salesorders_pkey FROM
                salesorders as a JOIN customer_addresses as b
            ON a.customers_fkey = b.customers_fkey
            WHERE open = true
                AND customer_addresses_pkey = ?
                AND companies_fkey = ?
                AND type = 'DELIVERY'
        };

    my $result = $self->pg->db->query(
        $stmt,
        ($customer_addresses_pkey, $companies_pkey)
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;
    if (defined $hash) {
        return $hash->{salesorders_pkey};
    }
    return 0;
}
1;