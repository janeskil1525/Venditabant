package Invoice::Model::Item;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

sub insert ($self, $companies_pkey, $users_pkey, $invoiceitem) {
    my $stmt = qq {
        INSERT INTO invoice_items (
	        insby, modby, invoice_fkey, stockitem,
            quantity, price, vat, vatsum, netsum, total,
            vat_txt, discount_txt, discount, unit, account
        ) VALUES (
                (SELECT userid FROM users WHERE users_pkey = ?),
                (SELECT userid FROM users WHERE users_pkey = ?),
                ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        );
    };
    $self->db->query(
        $stmt,(
            $users_pkey,
            $users_pkey,
            $invoiceitem->{invoice_fkey},
            $invoiceitem->{stockitem},
            $invoiceitem->{quantity},
            $invoiceitem->{price},
            $invoiceitem->{vat},
            $invoiceitem->{vatsum},
            $invoiceitem->{netsum},
            $invoiceitem->{total},
            $invoiceitem->{vat_txt},
            $invoiceitem->{discount_txt},
            $invoiceitem->{discount},
            $invoiceitem->{unit},
            $invoiceitem->{account},
        )
    );
}

async sub load_items_list_p ($self, $companies_pkey, $users_pkey, $invoice_pkey) {

    my $result = $self->db->select(
        'invoice_items',
        ['invoice_items_pkey', 'invoice_fkey', 'stockitem', 'quantity', 'price','description', 'vat','vatsum','netsum','total'],
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

sub load_items_list ($self, $companies_pkey, $users_pkey, $invoice_pkey) {

    my $result = $self->db->select(
        'invoice_items',
        ['invoice_items_pkey', 'invoice_fkey', 'stockitem', 'quantity', 'price','description', 'vat','vatsum','netsum','total'],
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