package venditabant::Model::SalesorderHead;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

sub upsert ($self, $companies_pkey, $users_pkey, $data) {

    my $salesorders_stmt = qq{
        INSERT INTO salesorders (
                insby, modby, companies_fkey, users_fkey, customers_fkey, orderno
            ) VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT customers_pkey FROM customers WHERE customer = ?),
                    ?, ?, ?)
            ON CONFLICT (orderno)
            DO UPDATE SET modby = (SELECT userid FROM users WHERE users_pkey = ?),
                        moddatetime = now()
            RETURNING salesorders_pkey
    };

    my $salesorders_pkey= $self->db->query(
        $salesorders_stmt,
        (
            $users_pkey,
            $users_pkey,
            $companies_pkey,
            $data->{customer},
            $data->{orderno},
            $users_pkey,
        )
    )->hash->{salesorders_pkey};

    return $salesorders_pkey;
}

async sub get_open_so ($self, $companies_pkey, $customers_pkey) {

    my $result = $self->db->select(
        'salesorders',
        ['orderno'],
            {
                open           => 1,
                companies_fkey => $companies_pkey,
                customers_fkey => $customers_pkey
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;
    if ($hash) {
        return $hash->{orderno};
    }
    return 0;
}
1;