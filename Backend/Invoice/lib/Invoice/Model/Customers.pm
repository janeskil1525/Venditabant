package Invoice::Model::Customers;
use strict;
use warnings FATAL => 'all';


async sub load_customer_from_pkey ($self, $companies_pkey, $customers_pkey) {

    my $result = $self->db->select(
        'customers',
        undef,
        {
            companies_fkey      => $companies_pkey,
            customers_pkey      => $customers_pkey
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}
1;