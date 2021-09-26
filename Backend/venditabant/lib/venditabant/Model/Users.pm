package venditabant::Model::Users;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Digest::SHA qw{sha512_base64};

has 'db';

sub upsert ($self, $data) {

    $data->{password} = sha512_base64($data->{password});
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
            $data->{password},
            $data->{active},
            $data->{username},
            $data->{password},
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
        SELECT users_pkey, userid, username, active
            FROM users, users_companies
        WHERE users_pkey = users_fkey AND companies_fkey = ?
    };
    say "load_list";
    my $list = $self->db->query($load_stmt,($companies_pkey));

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}

sub load_list_support ($self) {
    my $load_stmt = qq {
        SELECT users_pkey, userid, username, active
            FROM users ORDER BY userid
    };
say "load_list_support";
    my $list = $self->db->query($load_stmt);

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}
1;