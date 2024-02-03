package venditabant::Helpers::Login;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Login;
use System::Helpers::Jwt;

use Data::Dumper;
use Digest::SHA qw{sha512_base64};
use Mojo::JSON qw {encode_json};

has 'pg';

async sub login_user ($self, $userid, $password) {

    $password = sha512_base64 $password;

    say "Password: " . Dumper($password);
    my $login = venditabant::Model::Login->new(
        pg => $self->pg
    )->login(
        $userid, $password
    );

    my $jwt;
    my $result;

    if($login) {
        #my $json = encode_json($login);
        $jwt = await System::Helpers::Jwt->new()->encode_jwt_p($login);
        $result = {
            userid   => $userid,
            jwt      => $jwt,
            expires  => '',
            support => $login->{support}
        };
    }

    return $result;
}

sub authenticate ($self, $payload) {

    my $claim = System::Helpers::Jwt->new()->decode_jwt($payload);
    my $login = venditabant::Model::Login->new(
        pg => $self->pg
    )->check_creds(
        $claim->{userid}, $claim->{password}
    );

    return $login;
}
1;