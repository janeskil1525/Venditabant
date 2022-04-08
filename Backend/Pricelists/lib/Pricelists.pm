package Pricelists;
use Mojo::Base -base, -signatures, -async_await;

use Pricelists::Helpers::Pricelists;
use Data::Dumper;

our $VERSION = '0.03';

has 'pg';

async sub load_list_heads_p ($self, $companies_pkey) {
    return Pricelists::Helpers::Pricelists->new(
        pg => $self->pg
    )->load_list_heads_p(
        $companies_pkey
    );
}

sub upsert_head ($self, $companies_pkey, $pricelist) {
    return Pricelists::Helpers::Pricelists->new(
        pg => $self->pg
    )->upsert_head(
        $companies_pkey, $pricelist
    );
}

async sub upsert_head_p ($self, $companies_pkey, $pricelist) {
    return Pricelists::Helpers::Pricelists->new(
        pg => $self->pg
    )->upsert_head(
        $companies_pkey, $pricelist
    );
}

async sub load_list_items_p ($self, $companies_pkey, $pricelists_fkey) {
    return Pricelists::Helpers::Pricelists->new(
        pg => $self->pg
    )->load_list_items_p(
        $companies_pkey, $pricelists_fkey
    );
}

async sub insert_item_p ($self, $companies_pkey, $pricelist_item) {
    return Pricelists::Helpers::Pricelists->new(
        pg => $self->pg
    )->insert_item_p(
        $companies_pkey, $pricelist_item
    );
}

sub insert_item ($self, $companies_pkey, $pricelist_item) {
    return Pricelists::Helpers::Pricelists->new(
        pg => $self->pg
    )->insert_item (
        $companies_pkey, $pricelist_item
    );
}

async sub prepare_upsert_from_stockitem_p ($self, $companies_pkey, $stockitems_pkey, $price) {
    return Pricelists::Helpers::Pricelists->new(
        pg => $self->pg
    )->prepare_upsert_from_stockitem_p(
        $companies_pkey, $stockitems_pkey, $price
    );
}

sub prepare_upsert_from_stockitem ($self, $companies_pkey, $stockitems_pkey, $price) {
    return Pricelists::Helpers::Pricelists->new(
        pg => $self->pg
    )->prepare_upsert_from_stockitem (
        $companies_pkey, $stockitems_pkey, $price
    );
}
1;