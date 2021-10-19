package venditabant::Helpers::Salesorder::Salesorders;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::SalesorderHead;
use venditabant::Model::Counter;
use venditabant::Model::SalesorderItem;

use Data::Dumper;

has 'pg';

async sub load_salesorder_items_list ($self, $companies_pkey, $users_pkey, $salesorders_fkey) {

    my $result;
    my $err;
    eval {
        $result = await venditabant::Model::SalesorderItem->new(
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
        $result = venditabant::Model::SalesorderHead->new(
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
        $result = venditabant::Model::SalesorderHead->new(
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

async sub upsert ($self, $companies_pkey, $users_pkey, $data) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $sohead = venditabant::Model::SalesorderHead->new(db => $db);

        my $orderno = await $sohead->get_open_so(
            $companies_pkey, $data->{customer}
        );

        if( !defined $orderno or $orderno == 0) {
            my $counter = venditabant::Model::Counter->new(db => $db);
            $orderno = await $counter->nextid(
                $companies_pkey, $users_pkey, 'salesorder'
            );
        }

        $data->{orderno} = $orderno;
        my $salesorderhead_pkey = await $sohead->upsert(
            $companies_pkey, $users_pkey, $data
        );

        if($data->{quantity} > 0) {
            await venditabant::Model::SalesorderItem->new(
                db => $db
            )->upsert(
                $companies_pkey, $salesorderhead_pkey, $users_pkey, $data
            );
        } else {
            await venditabant::Model::SalesorderItem->new(
                db => $db
            )->delete_item(
                $companies_pkey, $salesorderhead_pkey, $data
            );
        }

        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;

    return $err ? $err : 'success';
}

async sub close ($self, $companies_pkey, $users_pkey, $data){

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $salesorder_statistics = qq{
        INSERT INTO salesorder_statistics (salesorders_fkey, stockitems_fkey, customers_fkey,
            users_fkey, companies_fkey, orderdate, deliverydate, quantity, price)
        SELECT salesorders_pkey, stockitems_fkey, customers_fkey,
            users_fkey, companies_fkey, orderdate, deliverydate, quantity, price
                FROM salesorders JOIN salesorder_items ON salesorders_pkey = salesorders_fkey
                    where salesorders_pkey = ?
    };

    my $err;
    eval {

        my $salesorders_pkey = await venditabant::Model::SalesorderHead->new(
            db => $db
        )->close(
            $companies_pkey, $users_pkey, $data->{customer}
        );

        $db->query($salesorder_statistics,($salesorders_pkey));
        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;

    return $err ? $err : 'success';
}
1;