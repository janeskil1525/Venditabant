package venditabant::Helpers::Login;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Login;
use venditabant::Helpers::Jwt;

use Data::Dumper;
use Digest::SHA qw{sha512_base64};
use Mojo::JSON qw {encode_json};

has 'pg';

async sub login_user ($self, $userid, $password) {

    $password = sha512_base64 $password;

    my $login = venditabant::Model::Login->new(
        pg => $self->pg
    )->login(
        $userid, $password
    );

    my $jwt;
    my $result;

    if($login) {
        #my $json = encode_json($login);
        $jwt = await venditabant::Helpers::Jwt->new()->encode_jwt_p($login);
        $result = {
            userid  => $userid,
            jwt     => $jwt,
            expires => '',
        };
    }

    return $result;
}

sub authenticate ($self, $payload) {

    my $claim = venditabant::Helpers::Jwt->new()->decode_jwt($payload);
    my $login = venditabant::Model::Login->new(
        pg => $self->pg
    )->check_creds(
        $claim->{userid}, $claim->{password}
    );

    return $login;
}
1;