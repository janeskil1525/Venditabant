package Suppliers::Helpers::Suppliers;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Suppliers::Model::Suppliers;

has 'pg';

async sub load_supplier_p($self, $companies_pkey, $users_pkey, $supplier) {
    return Suppliers::Model::Suppliers->new(
        db => $self-pg->db
    )->load_supplier_p(
        $companies_pkey, $users_pkey, $supplier
    );
}

sub load_supplier($self, $companies_pkey, $users_pkey, $supplier) {
    return Suppliers::Model::Suppliers->new(
        db => $self->pg->db
    )->load_supplier(
        $companies_pkey, $users_pkey, $supplier
    );
}
1;