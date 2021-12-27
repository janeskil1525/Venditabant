package venditabant::Model::Salesorder::Head;
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