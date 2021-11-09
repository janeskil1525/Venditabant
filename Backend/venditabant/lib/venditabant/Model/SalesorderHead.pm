package venditabant::Model::SalesorderHead;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub load_salesorder ($self, $companies_pkey, $users_pkey, $salesorders_pkey) {

    my $result = $self->db->select (
        'salesorders', ['*'],
            {
                companies_fkey    => $companies_pkey,
                salesorders_pkey => $salesorders_pkey,
            }
    );

    my $hash;
    $hash = $result->hash if $result->rows;
    return $hash;
}

async sub load_salesorder_list ($self, $companies_pkey, $users_pkey, $open) {

    my $stmt = qq{
        SELECT salesorders_pkey, customers_fkey, users_fkey, orderdate, deliverydate, open, orderno, customer
            FROM salesorders as a JOIN customers as b ON customers_fkey = customers_pkey
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

async sub upsert ($self, $companies_pkey, $users_pkey, $data) {

    my $salesorders_stmt = qq{
        INSERT INTO salesorders (
                insby, modby, companies_fkey, users_fkey, customers_fkey, orderno
            ) VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?,?)
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
            $data->{customers_fkey},
            $data->{orderno},
            $users_pkey,
        )
    )->hash->{salesorders_pkey};

    return $salesorders_pkey;
}

async sub get_open_so ($self, $companies_pkey, $customer_fkey) {

    my $soopen_stmt = qq {
        SELECT orderno FROM salesorders
            WHERE open = true AND
            companies_fkey = ?
            AND customers_fkey = ?
    };
    my $result = $self->db->query(
        $soopen_stmt,
        ($companies_pkey, $customer_fkey)
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

async sub close ($self, $companies_pkey, $users_pkey, $customer_fkey) {

    my $soclose_stmt = qq {
        UPDATE salesorders SET open = false,
            modby = (SELECT userid FROM users WHERE users_pkey = ?),
            moddatetime = now()
            WHERE open = true AND
            companies_fkey = ?
            AND customers_fkey = ?
        RETURNING salesorders_pkey
    };

    my $result = $self->db->query(
        $soclose_stmt,
        ($users_pkey, $companies_pkey, $customer_fkey)
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;
    if (defined $hash) {
        return $hash->{salesorders_pkey};
    }
    return 0;
}

async sub invoice ($self, $salseorders_pkey) {

    $self->db->update(
        'salesorders',
            {
                invoiced => 'true'
            },
            {
                salesorders_pkey => $salseorders_pkey
            }
    );
}
1;