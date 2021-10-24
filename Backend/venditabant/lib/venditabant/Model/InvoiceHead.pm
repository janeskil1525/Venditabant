package venditabant::Model::InvoiceHead;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';


async sub load_invoice_list ($self, $companies_pkey, $users_pkey, $open) {

    my $stmt = qq{
        SELECT invoice_pkey, customers_fkey, invoicedate, paydate, open, invoiceno, customer
            FROM invoice as a JOIN customers as b ON customers_fkey = customers_pkey
        WHERE a.companies_fkey = ? and open = ?
    };

    my $result = await $self->db->query_p(
        $stmt,
        (
            $companies_pkey, $open
        )
    );

    my $hash;
    $hash = $result->hashes if $result->rows;
    return $hash;
}



1;