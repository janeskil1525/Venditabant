package venditabant::Model::Users;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

has 'pg';
has 'db';

sub upsert ($self, $data) {

    my $users_stmt = qq{
        INSERT INTO users (userid, username, passwd, active) VALUES (?,?,?,?)
            ON CONFLICT (userid)
            DO UPDATE SET username = ?, passwd = ?, active = ?
        RETURNING users_pkey
    };

    my $users_pkey = $self->db->query(
        $users_stmt,
        (
            $data->{userid},
            $data->{username},
            $data->{passwd},
            $data->{active},
            $data->{username},
            $data->{passwd},
            $data->{active},
        )
    )->hash->{users_pkey};

    return $users_pkey;
}

sub upsert_user_companies ($self, $companies_pkey, $users_pkey) {

    my $users_stmt = qq {
        INSERT INTO users_companies (companies_fkey, users_fkey) VALUES (?,?)
            ON CONFLICT (companies_fkey, users_fkey)
            DO NOTHING
        RETURNING users_companies_pkey;
    };

    my $users_companies_pkey = $self->db->query(
        $users_stmt,
        (
            $companies_pkey,
            $users_pkey
        )
    )->hash->{users_companies_pkey};

    return $users_companies_pkey;
}

sub load_list ($self, $companies_pkey) {
    my $load_stmt = qq {
        SELECT stockitems_pkey, stockitem, description
            FROM stockitems
        WHERE companies_fkey = ?
    };

    my $list = $self->pg->db->query($load_stmt,($companies_pkey));

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}
1;