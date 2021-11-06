package venditabant::Model::AutoTodo;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

async sub load_list_p ($self, $companies_fkey) {

    my $result = $self->db->select(
        'auto_todo', undef,
            {
                companies_fkey => $companies_fkey
            }
    );

    my $hash;

    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}

async sub upsert_simple($self, $companies_fkey, $check) {
    my $stmt = qq{
        INSERT INTO auto_todo (companies_fkey, check_type, check_name, user_action, key_id)
            VALUES (?,?,?,(select translation from translations JOIN companies
	                    ON translations.languages_fkey = companies.languages_fkey
                            AND companies_pkey = ?
	                    WHERE module = ? AND tag = ?), 0)
        ON CONFLICT (companies_fkey, check_type, check_name, key_id)
            DO UPDATE SET moddatetime = now()
        RETURNING auto_todo_pkey;
    };

    my $auto_todo_pkey = $self->db->query(
        $stmt,(
            $companies_fkey,
            $check->{check_type},
            $check->{check_name},
            $companies_fkey,
            $check->{check_type},
            $check->{check_name},
        )
    )->hash->{auto_todo_pkey};

    return $auto_todo_pkey;
}

async sub upsert_user_action ($companies_pkey, $check_type, $check_name, $user_action, $key_id) {
    my $stmt = qq{
        INSERT INTO auto_todo (companies_fkey, check_type, check_name, user_action, key_id)
            VALUES (?,?,?,?,? )
        ON CONFLICT (companies_fkey, check_type, check_name, key_id)
            DO UPDATE SET moddatetime = now()
        RETURNING auto_todo_pkey;
    };

    my $auto_todo_pkey = $self->db->query(
        $stmt,(
        $companies_fkey,
        $check_type,
        $check_name,
        $user_action,
        $key_id
    )
    )->hash->{auto_todo_pkey};

    return $auto_todo_pkey;
}
1;