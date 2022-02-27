package Customers::Helpers::Customer;
use Mojo::Base -base, -signatures;


use Data::Dumper;

has 'pg';

sub invoice_customer ($self, $customer_pkey) {

    my $result = $self->pg->db->select(
        ['customers', ['customer_addresses',  customers_fkey => 'customers_pkey']],
            [
                'customers_pkey', 'customer_addresses_pkey', 'customer', 'name', 'address1', 'address2',
                'address3', 'city', 'zipcode', 'comment', 'mail_invoice', 'reference', 'homepage', 'languages_fkey'
            ],
            {
                customers_pkey => $customer_pkey,
                type           => 'INVOICE'
            }
    );

    my $hash;
    $hash = $result->hash if defined $result and $result->rows() > 0;

    return $hash;
}
1;