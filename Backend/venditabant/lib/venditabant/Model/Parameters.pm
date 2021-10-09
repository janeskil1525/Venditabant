package venditabant::Model::Parameters;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

async sub load_parameter_p ($self, $companies_pkey, $parameter) {

    my $result = await $self->db->select_p('parameters',
        undef,
        {
            companies_fkey => $companies_pkey,
            parameter      => $parameter,
        }
    );

    my $hash;
    $hash = $result->hash if $result->rows;

    return $hash;
}

async sub load_parameter_pkey_p ($self, $companies_pkey, $parameter) {

    my $result = await $self->db->select_p('parameters',
        ['parameters_pkey'],
        {
            companies_fkey => $companies_pkey,
            parameter      => $parameter,
        }
    );

    my $parameters_pkey = 0;
    $parameters_pkey = $result->hash->{parameters_pkey} if $result->rows;

    return $parameters_pkey;
}

async sub upsert_p ($self, $companies_pkey, $users_pkey, $parameter) {

    my $stmt = qq {
        INSERT INTO parameters (insby, modby, companies_fkey, parameter)
            VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),
                ?,?)
        ON CONFLICT (companies_fkey, parameter)
            DO UPDATE SET modby = (SELECT userid FROM users WHERE users_pkey = ?),
                            moddatetime = now()
        RETURNING parameters_pkey
    };

    my $parameter_pkey = $self->db->query(
        $stmt,
        (
            $users_pkey,
            $users_pkey,
            $companies_pkey,
            $parameter,
            $users_pkey
        )
    )->hash->{parameters_pkey};

    return $parameter_pkey;

}
1;