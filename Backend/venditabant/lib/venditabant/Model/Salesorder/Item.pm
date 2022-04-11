package venditabant::Model::Salesorder::Item;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub load_items_list ($self, $companies_pkey, $users_pkey, $salesorders_pkey) {

    my $result = $self->db->select(
        'salesorder_items',
        ['salesorder_items_pkey', 'salesorders_fkey', 'stockitem', 'description',
                    'quantity', 'price','unit', 'account','vat'],
            {
                salesorders_fkey => $salesorders_pkey
            },
            {
                order_by => 'stockitem'
            }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}

async sub get_orderitems ($self, $salesorders_pkey) {

    my $result = $self->db->select(
        'salesorder_items',
        undef,
            {
                salesorders_fkey => $salesorders_pkey
            }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}
1;