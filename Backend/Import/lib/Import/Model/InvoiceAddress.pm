package Import::Model::InvoiceAddress;
use Mojo::Base -base, -signatures, -async_await;

has 'db';

sub load_invoice_address_p($self, $customers_pkey) {

    my $result = $self->db->select(
        'customer_addresses',
        undef,
        {
            customers_fkey => $customers_pkey,
            type           => 'INVOICE'
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}

1;