package venditabant::Controller::Signup;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw{decode_json};
use venditabant::Helpers::Signup::Signup;
use Sentinel::Helpers::Sentinelsender;

use Data::Dumper;

sub signup_company ($self) {

    $self->render_later();

    my $json_hash = decode_json ($self->req->body);
    my $signup = venditabant::Helpers::Signup::Signup->new(
        pg => $self->pg
    );

    $signup->signup($json_hash)->then(sub ($result){
        $self->render(json => {'result' => $result});
    })->catch(sub ($err) {
        Sentinel::Helpers::Sentinelsender->new(
        )->capture_message(
            $self->pg,'','venditabant::Controller::Signup','signup_company',$err
        );
        $self->render(json => {'result' => $err});
    })->wait;
}

1;