package venditabant::Model::InvoiceStatus;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub insert ($self, $companies_pkey, $users_pkey, $invoice_pkey, $status) {
    my $stmt = qq {
        INSERT INTO invoice_status (
	        insby, modby, invoice_fkey, status
        ) VALUES (
                (SELECT userid FROM users WHERE users_pkey = ?),
                (SELECT userid FROM users WHERE users_pkey = ?),
                ?, ?
        );
    };
    $self->db->query(
        $stmt,(
            $users_pkey,
            $users_pkey,
            $invoice_pkey,
            $status
        )
    );
}

1;