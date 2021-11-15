package venditabant::Model::Supplier::Suppliers;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub load_supplier($self, $companies_pkey, $users_pkey, $supplier) {

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