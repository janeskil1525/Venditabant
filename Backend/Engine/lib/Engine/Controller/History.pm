package Engine::Controller::History;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {decode_json};

sub list ($self) {

    $self->render_later;
    my $hist_type = $self->param('hist_type');
    my $hist_key = $self->param('hist_key');


    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    $self->history->load_list(
        $companies_pkey, $hist_type, $hist_key)->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {
        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}
1;