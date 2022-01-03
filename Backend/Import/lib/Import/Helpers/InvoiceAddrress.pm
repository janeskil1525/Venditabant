package Import::Helpers::InvoiceAddrress;
use Mojo::Base -base, -signatures, -async_await;

use Import::Model::InvoiceAddress;

use Data::Dumper;

has 'pg';

sub load_invoice_address_p($self, $companies_pkey, $users_pkey, $customers_pkey) {

    my $result = Import::Model::InvoiceAddress->new(
        db => $self->pg->db
    )->load_invoice_address_p(
        $customers_pkey
    );

    return $result;
}

1;