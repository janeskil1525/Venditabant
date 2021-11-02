package venditabant::Controller::Systemsettings;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use venditabant::Helpers::Jwt;

use Data::Dumper;
use Mojo::JSON qw {from_json};

sub save_parameter_encoded ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $json_hash = from_json ($self->req->body);
    my $jwt->{value} = await venditabant::Helpers::Jwt->new()->encode_jwt_p($json_hash->{value});
    $jwt->{setting} = $json_hash->{setting};
    $self->systemsettings->upsert($companies_pkey, $users_pkey, $jwt)->then(sub ($result) {
        $self->render(json => {'result' => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;

}
1;