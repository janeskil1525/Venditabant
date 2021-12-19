package Engine::Model::Salesorder::Head;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';


sub upsert ($self, $companies_pkey, $users_pkey, $data) {

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

    my $salesorders_pkey = $self->db->query(
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

async sub close ($self, $companies_pkey, $users_pkey, $salesorders_pkey) {

    my $soclose_stmt = qq {
        UPDATE salesorders SET open = false,
            modby = (SELECT userid FROM users WHERE users_pkey = ?),
            moddatetime = now()
            WHERE open = true AND
            salesorders_pkey = ?
        RETURNING salesorders_pkey
    };

    my $result = $self->db->query(
        $soclose_stmt,
        ($users_pkey, $salesorders_pkey)
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