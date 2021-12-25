package venditabant::Helpers::Salesorder::Salesorders;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Salesorder::Head;
use venditabant::Model::Salesorder::Item;
use venditabant::Model::Counter;
use venditabant::Helpers::Customers::Address;
use venditabant::Model::Stockitems;
#use venditabant::Helpers::Salesorder::PrepareItem;

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

# async sub item_upsert($self, $companies_pkey, $users_pkey, $data) {
#     my $db = $self->pg->db;
#     my $tx = $db->begin();
#
#     my $err;
#     eval {
#
#         if($data->{quantity} > 0) {
#             $data = await venditabant::Helpers::Salesorder::PrepareItem->new(
#                 pg => $self->pg
#             )->prepare_item(
#                 $companies_pkey, $users_pkey, $data->{stockitems_fkey}, $data
#             );
#
#             await venditabant::Model::Salesorder::Item->new(
#                 db => $db
#             )->upsert(
#                 $companies_pkey, $data->{salesorders_fkey}, $users_pkey, $data
#             );
#         } else {
#             await venditabant::Model::Salesorder::Item->new(
#                 db => $db
#             )->delete_item(
#                 $companies_pkey, $data->{salesorders_fkey}, $data
#             );
#         }
#
#         $tx->commit();
#     };
#     $err = $@ if $@;
#     $self->capture_message (
#         $self->pg, '',
#         'venditabant::Helpers::Salesorder::Salesorders', 'item_upsert', $err
#     ) if $err;
#
#     return $err ? $err : 'success';
# }
# async sub upsert ($self, $companies_pkey, $users_pkey, $data) {
#
#     my $db = $self->pg->db;
#     my $tx = $db->begin();
#
#     my $err;
#     eval {
#         my $customer_addresses = await venditabant::Helpers::Customers::Address->new(
#             pg => $self->pg
#         )->load_delivery_address_p(
#             $companies_pkey, $users_pkey, $data->{customer_addresses_pkey}
#         );
#         my $customer_fkey = $customer_addresses->{customers_fkey};
#
#         $data->{customers_fkey} = $customer_fkey;
#         my $sohead = venditabant::Model::Salesorder::Head->new(db => $db);
#
#         my $orderno = await $sohead->get_open_so(
#             $companies_pkey, $customer_fkey
#         );
#
#         if( !defined $orderno or $orderno == 0) {
#             my $counter = venditabant::Model::Counter->new(db => $db);
#             $orderno = await $counter->nextid(
#                 $companies_pkey, $users_pkey, 'salesorder'
#             );
#         }
#
#         say Dumper($data);
#
#         $data->{orderno} = $orderno;
#         my $salesorderhead_pkey = await $sohead->upsert(
#             $companies_pkey, $users_pkey, $data
#         );
#
#         if($data->{quantity} > 0) {
#             $data = await venditabant::Helpers::Salesorder::PrepareItem->new(
#                 pg => $self->pg
#             )->prepare_item(
#                 $companies_pkey, $users_pkey, $data->{stockitems_fkey}, $data
#             );
#
#             await venditabant::Model::Salesorder::Item->new(
#                 db => $db
#             )->upsert(
#                 $companies_pkey, $salesorderhead_pkey, $users_pkey, $data
#             );
#         } else {
#             await venditabant::Model::Salesorder::Item->new(
#                 db => $db
#             )->delete_item(
#                 $companies_pkey, $salesorderhead_pkey, $data
#             );
#         }
#
#         $tx->commit();
#     };
#     $err = $@ if $@;
#     $self->capture_message (
#         $self->pg, '',
#         'venditabant::Helpers::Salesorder::Salesorders', 'upsert', $@
#     ) if $err;
#
#     return $err ? $err : 'success';
# }

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