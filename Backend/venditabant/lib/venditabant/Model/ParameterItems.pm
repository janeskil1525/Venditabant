package venditabant::Model::ParameterItems;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

async sub load_parameter_p ($self, $parameters_fkey, $parameter) {

    my $result = await $self->db->select_p('parameters_items',
        undef,
        {
            parameters_fkey => $parameters_fkey,
        }
    );

    my $hash;
    $hash = $result->hashes if $result->rows;

    return $hash;
}

async sub upsert_p ($self, $users_pkey, $parameters_pkey, $param_value, $param_description, $parameters_items_pkey) {

    # parameters_items_pkey avail but not used at the moment
    my $salesorder_item_stmt = qq{
        INSERT INTO parameters_items (
                insby, modby, parameters_fkey, param_value, param_description
            ) VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?, ?, ?)
            ON CONFLICT (parameters_fkey, param_value)
            DO UPDATE SET modby = (SELECT userid FROM users WHERE users_pkey = ?),
                        moddatetime = now(),
                        param_description = ?
            RETURNING parameters_items_pkey
    };

    my $parameters_items_pkey = $self->db->query(
        $salesorder_item_stmt,
        (
            $users_pkey,
            $users_pkey,
            $parameters_pkey,
            $param_value,
            $param_description,
            $users_pkey,
            $param_description,
        )
    )->hash->{parameters_items_pkey};

    return $parameters_items_pkey;
}

async sub delete_p ($self, $parameters_items_pkey) {

    return $self->db->delete_p(
        'parameters_items',
        {
            parameters_items_pkey => $parameters_items_pkey
        }
    );
}
1;