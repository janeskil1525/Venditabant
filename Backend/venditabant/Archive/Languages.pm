package venditabant::Controller::Languages;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {from_json};


sub load_list ($self) {

    $self->render_later;
    $self->languages->load_list()->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

1;