package venditabant::Helpers::Pricelist::Pricefinder;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Pricelists;
use venditabant::Model::PricelistItems;
use venditabant::Model::Customer::Customers;

use DateTime;
use Data::Dumper;

has 'pg';

async sub find_price($self, $companies_pkey, $users_pkey, $customers_fkey, $stockitems_fkey) {

    my $pricelist = await venditabant::Model::Customer::Customers->new(
        db => $self->pg->db)->load_customer_pricelist_from_pkey(
        $companies_pkey,$customers_fkey
    );


}

1;