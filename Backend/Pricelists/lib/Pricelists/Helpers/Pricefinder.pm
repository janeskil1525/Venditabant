package Pricelists::Helpers::Pricefinder;
use Mojo::Base -base, -signatures, -async_await;

use Pricelists::Model::Pricelists;
use Pricelists::Model::PricelistItems;
use Customers::Model::Customers;

use DateTime;
use Data::Dumper;

has 'pg';

async sub find_price($self, $companies_pkey, $users_pkey, $customers_fkey, $stockitems_fkey) {

    my $pricelist = await Customers::Model::Customers->new(
        db => $self->pg->db)->load_customer_pricelist_from_pkey(
        $companies_pkey, $customers_fkey
    );


}

1;