package venditabant::Model::Invoice::InvoiceHead;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub insert ($self, $companies_pkey, $users_pkey, $invoicehead) {
    my $stmt = qq {
        INSERT INTO invoice (
	        insby,  modby, customers_fkey, companies_fkey, invoicedate, paydate, invoiceno,
            address1, address2, address3, city, zipcode, country, mailaddresses, vatsum,
            netsum, total, salesorder_fkey, invoicedays
        ) VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),
                        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        )
        RETURNING invoice_pkey;
    };

    my $result = $self->db->query($stmt,(
        $users_pkey,
        $users_pkey,
        $invoicehead->{customers_fkey},
        $invoicehead->{companies_fkey},
        $invoicehead->{invoicedate},
        $invoicehead->{paydate},
        $invoicehead->{invoiceno},
        $invoicehead->{address1},
        $invoicehead->{address2},
        $invoicehead->{address3},
        $invoicehead->{city},
        $invoicehead->{zipcode},
        $invoicehead->{country},
        $invoicehead->{mailadresses},
        $invoicehead->{vatsum},
        $invoicehead->{netsum},
        $invoicehead->{total},
        $invoicehead->{salesorders_fkey},
        $invoicehead->{invoicedays}
    ))->hash();

    return $result->{invoice_pkey};

}


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

async sub load_invoice($self, $companies_pkey, $users_pkey, $invoice_fkey) {

    my $result = $self->db->select (
        'invoice', ['*'],
        {
            companies_fkey    => $companies_pkey,
            invoice_pkey => $invoice_fkey,
        }
    );

    my $hash;
    $hash = $result->hash if $result->rows;
    return $hash;
}

1;