package venditabant::Model::Warehouses;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

sub upsert ($self, $companies_pkey, $users_pkey, $warehouse) {

    my $customer_stmt = qq{
        INSERT INTO warehouses (insby, modby, companies_fkey, warehouse, warehouse_name)
            VALUES ((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?)
            ON CONFLICT (companies_fkey, warehouse)
        DO UPDATE SET warehouse_name = ?,
            moddatetime = now(),
            modby = (SELECT userid FROM users WHERE users_pkey = ?)
        RETURNING warehouses_pkey
    };

    my $customers_pkey = $self->db->query(
        $customer_stmt,
        (
            $users_pkey,
            $users_pkey,
            $companies_pkey,
            $warehouse->{warehouse},
            $warehouse->{warehouse_name},
            $warehouse->{warehouse_name},
            $users_pkey,
        )
    )->hash->{warehouses_pkey};

    return $customers_pkey;
}

async sub load_list_p ($self, $companies_pkey, $users_pkey) {

    my $list = $self->db->select(
        'warehouses',undef,
            {
                companies_fkey => $companies_pkey
            }
    );

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}

1;