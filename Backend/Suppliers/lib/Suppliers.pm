package Suppliers;
use Mojo::Base -base, -signatures, -async_await;

use Suppliers::Helpers::Suppliers;
use Suppliers::Model::Stockitems;

use Data::Dumper;

our $VERSION = '0.02';

has 'pg';

async sub upsert_supplieritem_p($self, $companies_pkey, $users_pkey, $data) {
    return Suppliers::Model::Stockitems->new(
        db => $self->pg->db
    )->upsert_supplieritem_p(
        $companies_pkey, $users_pkey, $data
    );
}

sub upsert_supplieritem($self, $companies_pkey, $users_pkey, $data) {
    return Suppliers::Model::Stockitems->new(
        db => $self->pg->db
    )->upsert_supplieritem(
        $companies_pkey, $users_pkey, $data
    );
}

async sub load_supplier_p($self, $companies_pkey, $users_pkey, $supplier) {
    return Suppliers::Helpers::Suppliers->new(
        pg => $self->pg
    )->load_supplier_p(
        $companies_pkey, $users_pkey, $supplier
    );
}

sub load_supplier($self, $companies_pkey, $users_pkey, $supplier) {
    return Suppliers::Helpers::Suppliers->new(
        pg => $self->pg
    )->load_supplier(
        $companies_pkey, $users_pkey, $supplier
    );
}
1;