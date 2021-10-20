package venditabant::Helpers::Signup::Signup;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Companies::Release::Release;

use Digest::SHA qw{sha512_base64};

has 'pg';

async sub signup ($self, $data) {

    my $db = $self->pg->db;
    my $tx = $db->begin;
    my $company_stmt = qq {
        INSERT INTO companies (company, registrationnumber, languages_fkey)
        VALUES (?, ?,(SELECT languages_pkey FROM languages WHERE lan = 'swe'))
        RETURNING companies_pkey;
    };

    my $users_stmt = qq {
        INSERT INTO users (userid, username, passwd, active, languages_fkey)
        VALUES (?,?,?,?, (SELECT languages_pkey FROM languages WHERE lan = 'swe'))
        RETURNING users_pkey;
    };

    my $users_companies_stmt = qq {
        INSERT INTO users_companies (companies_fkey, users_fkey) VALUES (?,?);
    };

    $data->{password} = sha512_base64($data->{password});
    my $err = '';
       # company_address:company_address,
    eval {

        my $companies_pkey = $db->query($company_stmt,($data->{company_name}, $data->{company_orgnr}))->hash->{companies_pkey};
        my $users_pkey = $db->query($users_stmt,($data->{email}, $data->{user_name},$data->{password},1))->hash->{users_pkey};
        $db->query($users_companies_stmt,($companies_pkey, $users_pkey));
        await venditabant::Helpers::Companies::Release::Release->new(
            db => $db
        )->release_single_company($companies_pkey);

        $tx->commit;
    };
    $err = $@ if $@;
    $self->capture_message ($self->pg, '',
        'venditabant::Helpers::Signup::Signup', 'signup', $err
    ) if $err;


    if($err) {
        return $err;
    } else {
        return 'success';
    }
}
1;