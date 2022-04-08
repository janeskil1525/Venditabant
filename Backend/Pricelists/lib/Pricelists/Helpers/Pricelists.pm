package Pricelists::Helpers::Pricelists;
use Mojo::Base -base, -signatures, -async_await;

use Pricelists::Model::Pricelists;
use Pricelists::Model::PricelistItems;

use DateTime;
use Data::Dumper;

has 'pg';

async sub load_list_heads_p ($self, $companies_pkey) {


    my $result = await Pricelists::Model::Pricelists->new(
        db => $self->pg->db
    )->load_list_heads_p(
        $companies_pkey
    );

    return $result;
}

sub upsert_head ($self, $companies_pkey, $pricelist) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $pricelists_pkey = Pricelists::Model::Pricelists->new(
            db => $db
        )->upsert(
            $companies_pkey, $pricelist
        );
        $tx->commit();
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}

async sub upsert_head_p ($self, $companies_pkey, $pricelist) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $pricelists_pkey = Pricelists::Model::Pricelists->new(
            db => $db
        )->upsert(
            $companies_pkey, $pricelist
        );
        $tx->commit();
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}

async sub load_list_items_p ($self, $companies_pkey, $pricelists_fkey) {

    my $result = await Pricelists::Model::PricelistItems->new(
        db => $self->pg->db
    )->load_list_items_p(
        $companies_pkey, $pricelists_fkey
    );

    return $result;
}

sub insert_item ($self, $companies_pkey, $pricelist_item) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $pricelists_pkey = 0;
    my $err;
    eval {
        $pricelists_pkey = Pricelists::Model::PricelistItems->new(
            db => $db
        )->insert_item(
            $companies_pkey, $pricelist_item
        );
        $tx->commit();
    };
    $err = $@ if $@;

    return $pricelists_pkey;
}

async sub insert_item_p ($self, $companies_pkey, $pricelist_item) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $pricelists_pkey = Pricelists::Model::PricelistItems->new(
            db => $db
        )->insert_item(
            $companies_pkey, $pricelist_item
        );
        $tx->commit();
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}

async sub prepare_upsert_from_stockitem_p ($self, $companies_pkey, $stockitems_pkey, $price) {

    my $pricelists_item;
    my $err;
    eval {
        my $pricelists_fkey = await Pricelists::Model::Pricelists->new(
            db => $self->pg->db
        )->get_pricelist_pkey_p(
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

    return $pricelists_item;
}

sub prepare_upsert_from_stockitem ($self, $companies_pkey, $stockitems_pkey, $price) {

    my $pricelists_item;
    my $err;
    eval {
        my $pricelists_fkey = Pricelists::Model::Pricelists->new(
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

    return $pricelists_item;
}
1;