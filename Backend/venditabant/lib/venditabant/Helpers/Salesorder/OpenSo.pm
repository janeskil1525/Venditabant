package venditabant::Helpers::Salesorder::OpenSo;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'pg';


async sub get_open_so_pkey($self, $companies_pkey, $users_pkey, $customer_addresses_pkey) {

        my $stmt = qq {
            SELECT salesorders_pkey FROM
                salesorders as a JOIN customer_addresses as b
            ON a.customers_fkey = b.customers_fkey
            WHERE open = true
                AND customer_addresses_pkey = ?
                AND companies_fkey = ?
                AND type = 'INVOICE'
        };

        my $result = $self->pg->db->query(
            $stmt,
            ($customer_addresses_pkey, $companies_pkey)
        );

        my $hash;
        $hash = $result->hash if $result and $result->rows;
        if (defined $hash) {
            return $hash->{salesorders_pkey};
        }
        return 0;
}
1;