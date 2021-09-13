package venditabant::Controller::Signup;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw{from_json};
use venditabant::Helpers::Signup;
use Data::Dumper;

sub signup_company ($self) {

    say 'signup_company 1';
    $self->render_later();
    say Dumper($self->req->body);

    my $json_hash = from_json ($self->req->body);
    say 'signup_company 2';
    my $signup = venditabant::Helpers::Signup->new(
        pg => $self->pg
    );
    say 'signup_company 3';
    $signup->signup($json_hash)->then(sub ($result){
        say 'signup_company 4';
        $self->render(json => {'result' => $result});
    })->catch(sub ($err) {
        say 'signup_company 5 ' . $err;
        $self->render(json => {'result' => $err});
    })->wait;
}

1;