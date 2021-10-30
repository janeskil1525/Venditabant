package venditabant::Model::Invoice::InvoiceItem;
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

async sub load_items_list ($self, $companies_pkey, $users_pkey, $invoice_pkey) {

    my $result = $self->db->select(
        ['invoice_items',['stockitems', stockitems_pkey => 'stockitems_fkey']],
        ['invoice_items_pkey', 'invoice_fkey', 'stockitems_fkey', 'stockitem', 'quantity', 'price'],
        {
            invoice_fkey => $invoice_pkey
        },
        {
            order_by => 'stockitem'
        }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}
1;