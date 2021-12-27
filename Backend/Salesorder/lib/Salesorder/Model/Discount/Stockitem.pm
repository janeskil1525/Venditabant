package Salesorder::Model::Discount::Stockitem;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';


async sub load_discount($self, $companies_pkey, $users_pkey, $customers_fkey, $stockitems_fkey) {

    my $result = $self->db->select(
        'stockitem_customer_discount',
        ['discount'],
        {
            customers_fkey => $customers_fkey,
            stockitems_fkey => $stockitems_fkey
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows();

    if(!exists $hash->{discount}) {
        $hash->{discount} = '';
    }

    return $hash;
}
1;