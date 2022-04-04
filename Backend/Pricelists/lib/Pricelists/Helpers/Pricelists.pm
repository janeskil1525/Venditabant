package venditabant::Helpers::Pricelist::Pricelists;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Pricelists;
use venditabant::Model::PricelistItems;

use DateTime;
use Data::Dumper;

has 'pg';

async sub load_list_heads ($self, $companies_pkey) {


    my $result = await venditabant::Model::Pricelists->new(
        db => $self->pg->db
    )->load_list_heads_p(
        $companies_pkey
    );

    return $result;
}

async sub upsert_head ($self, $companies_pkey, $pricelist) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $pricelists_pkey = venditabant::Model::Pricelists->new(
            db => $db
        )->upsert(
            $companies_pkey, $pricelist
        );
        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Pricelist::Pricelists;', 'upsert_head', $@
    ) if $err;

    return $err ? $err : 'success';
}

async sub load_list_items ($self, $companies_pkey, $pricelists_fkey) {

    my $result = await venditabant::Model::PricelistItems->new(
        db => $self->pg->db
    )->load_list_items_p(
        $companies_pkey, $pricelists_fkey
    );

    return $result;
}

async sub insert_item ($self, $companies_pkey, $pricelist_item) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $pricelists_pkey = venditabant::Model::PricelistItems->new(
            db => $db
        )->insert_item(
            $companies_pkey, $pricelist_item
        );
        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Pricelist::Pricelists;', 'insert_item', $@
    ) if $err;

    return $err ? $err : 'success';
}

async sub prepare_upsert_from_stockitem ($self, $companies_pkey, $stockitems_pkey, $price) {

    my $pricelists_item;
    my $err;
    eval {
        my $pricelists_fkey = await venditabant::Model::Pricelists->new(
            db => $self->pg->db
        )->get_pricelist_pkey(
            $companies_pkey, 'DEFAULT'
        );

        $pricelists_item->{stockitems_fkey} = $stockitems_pkey;
        $pricelists_item->{pricelists_fkey} = $pricelists_fkey;
        $pricelists_item->{price} = $price;
        my $now = DateTime->now();
        my $todate = DateTime->now()->add(years => 5);

        $pricelists_item->{fromdate} = "$now";
        $pricelists_item->{todate} = "$todate";

    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Pricelist::Pricelists;', 'prepare_upsert_from_stockitem', $@
    ) if $err;

    return $pricelists_item;
}
1;