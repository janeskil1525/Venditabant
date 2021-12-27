package Salesorder::Model::Discount::Productgroups;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub load_discount($self, $companies_pkey, $users_pkey, $customers_fkey, $productgroups_fkey) {

    my $result = $self->db->select(
        'productgroup_customer_discount',
        ['discount'],
        {
            customers_fkey => $customers_fkey,
            productgroups_fkey => $productgroups_fkey
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