package System::Helpers::Jwt;
use Mojo::Base -base,  -signatures, -async_await;

use Data::Dumper;
use Mojo::JWT;

has 'secret' => qw {lK1leAbOxGmUKdVmuMKbJtD7ru1wd2V9Y5e58zLPlL5UI4GP1AETmd7eZ3MRZEP};

async sub encode_jwt_p($self, $claim) {

    my $secret = $self->secret();
    my $jwt = Mojo::JWT->new(claims => $claim, secret => $secret)->encode;

    return $jwt
}

async sub decode_jwt_p($self, $jwt) {

    my $secret = $self->secret();
    my $claims = Mojo::JWT->new(secret => $secret)->decode($jwt);

    return $claims;
}

sub encode_jwt($self, $claim) {

    my $secret = $self->secret();
    my $jwt = Mojo::JWT->new(claims => $claim, secret => $secret)->encode;

    return $jwt
}

sub decode_jwt($self, $jwt) {

    my $secret = $self->secret();
    my $claims = Mojo::JWT->new(secret => $secret)->decode($jwt);

    return $claims;
}

sub companise_pkey ($self, $token) {

    my $jwt_hash = $self->decode_jwt($token);

    return $jwt_hash->{companies_pkey};
}

sub companies_users_pkey ($self, $token) {

    my $jwt_hash = $self->decode_jwt($token);

    return ($jwt_hash->{companies_pkey}, $jwt_hash->{users_pkey});
}
1;