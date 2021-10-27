package venditabant::Model::InvoiceItem;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub insert ($self, $companies_pkey, $users_pkey, $invoiceitem) {
    my $stmt = qq {
        INSERT INTO invoice_items (
	        insby, modby, invoice_fkey, stockitems_fkey,
            quantity, price, vat, vatsum, netsum, total
        ) VALUES (
                (SELECT userid FROM users WHERE users_pkey = ?),
                (SELECT userid FROM users WHERE users_pkey = ?),
                ?, ?, ?, ?, ?, ?, ?, ?
        );
    };
    $self->db->query(
        $stmt,(
            $users_pkey,
            $users_pkey,
            $invoiceitem->{invoice_fkey},
            $invoiceitem->{stockitems_fkey},
            $invoiceitem->{quantity},
            $invoiceitem->{price},
            $invoiceitem->{vat},
            $invoiceitem->{vatsum},
            $invoiceitem->{netsum},
            $invoiceitem->{total},
        )
    );
}

1;