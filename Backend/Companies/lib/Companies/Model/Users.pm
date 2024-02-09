package Companies::Model::Users;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Digest::SHA qw{sha512_base64};

has 'db';

sub insert ($self, $data) {

    $data->{password} = sha512_base64($data->{password});
    my $users_stmt = qq{
        INSERT INTO users (userid, username, passwd, active, languages_fkey) VALUES (?,?,?,?, ?)
            ON CONFLICT (userid)
            DO UPDATE SET moddatetime = now(), username = ?, passwd = ?, active = ?, languages_fkey = ?
        RETURNING users_pkey
    };

    my $users_pkey = $self->db->query(
        $users_stmt,
        (
            $data->{userid},
            $data->{username},
            $data->{password},
            $data->{active},
            $data->{languages_fkey},
            $data->{username},
            $data->{password},
            $data->{active},
            $data->{languages_fkey},
        )
    )->hash->{users_pkey};

    return $users_pkey;
}

sub upsert_user_companies ($self, $companies_pkey, $users_pkey) {

    my $users_stmt = qq {
        INSERT INTO users_companies (companies_fkey, users_fkey) VALUES (?,?)
            ON CONFLICT (companies_fkey, users_fkey)
            DO UPDATE SET moddatetime = now()
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
        SELECT users_pkey, userid, username, active, languages_fkey, lan
            FROM users, users_companies, languages
        WHERE users_pkey = users_fkey AND languages_fkey = languages_pkey AND companies_fkey = ?
    };
    say "load_list";
    my $list = $self->db->query($load_stmt,($companies_pkey));

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}

sub load_list_support ($self) {
    my $load_stmt = qq {
        SELECT users_pkey, userid, username, active, languages_fkey, lan
            FROM users, languages WHERE languages_fkey = languages_pkey ORDER BY username
    };

    my $list = $self->db->query($load_stmt);

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}

async sub load_user_from_pkey($self, $users_pkey) {
    my $result = $self->db->select(
        'users', ['*'],
            {
                users_pkey => $users_pkey
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}
1;