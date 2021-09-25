package venditabant::Model::Login;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -base, -signatures, -async_await;

use Data::Dumper;

has 'pg';

sub login ($self, $userid, $password) {

    my $login_stmt = qq{
        SELECT users_pkey, userid, username, is_admin, companies_pkey, company,
            passwd as password
            FROM users, companies, users_companies
           WHERE companies_pkey = companies_fkey AND users_pkey = users_fkey
            AND userid = ? AND passwd = ? AND active = 1
    };


    my $result = $self->pg->db->query($login_stmt,($userid, $password));

    my $hash;
    $hash = $result->hash if $result->rows;

    return $hash;
}

sub check_creds ($self, $userid, $password) {

    my $check_stmt = qq{
        SELECT count(*) as exists
            FROM users, companies, users_companies
           WHERE companies_pkey = companies_fkey AND users_pkey = users_fkey
            AND userid = ? AND passwd = ? AND active = 1
    };

    my $result = $self->pg->db->query(
        $check_stmt,($userid, $password)
    )->hash->{exists};

    return $result;
}
1;