package venditabant::Model::SalesorderHead;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub upsert ($self, $companies_pkey, $users_pkey, $data) {

    my $salesorders_stmt = qq{
        INSERT INTO salesorders (
                insby, modby, companies_fkey, users_fkey, customers_fkey, orderno
            ) VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,
                    (SELECT customers_pkey FROM customers WHERE customer = ?
                        AND companies_fkey = ?), ?)
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
            $users_pkey,
            $data->{customer},
            $companies_pkey,
            $data->{orderno},
            $users_pkey,
        )
    )->hash->{salesorders_pkey};

    return $salesorders_pkey;
}

async sub get_open_so ($self, $companies_pkey, $customer) {

    my $soopen_stmt = qq {
        SELECT orderno FROM salesorders
            WHERE open = true AND
            companies_fkey = ?
            AND customers_fkey = (SELECT customers_pkey
                                    FROM customers WHERE customer = ?
                                        AND companies_fkey = ?)
    };
    my $result = $self->db->query(
        $soopen_stmt,
        ($companies_pkey, $customer, $companies_pkey)
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;
    if (defined $hash) {
        return $hash->{orderno};
    }
    return 0;
}

async sub get_open_so_pkey ($self, $companies_pkey, $customer) {

    my $soopen_stmt = qq {
        SELECT salesorders_pkey FROM salesorders
            WHERE open = true AND
            companies_fkey = ?
            AND customers_fkey = (SELECT customers_pkey
                                    FROM customers WHERE customer = ?
                                        AND companies_fkey = ?)
    };
    my $result = $self->db->query(
        $soopen_stmt,
        ($companies_pkey, $customer, $companies_pkey)
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;
    if (defined $hash) {
        return $hash->{orderno};
    }
    return 0;
}
1;