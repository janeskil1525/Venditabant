package Suppliers::Model::Suppliers;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub load_supplier_p($self, $companies_pkey, $users_pkey, $supplier) {
    return $self->load_supplier($companies_pkey, $users_pkey, $supplier);
}

sub load_supplier($self, $companies_pkey, $users_pkey, $supplier) {
    my $result = $self->db->select(
        'suppliers',['*'],
        {
            supplier       => $supplier,
            companies_fkey => $companies_pkey,
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}
1;