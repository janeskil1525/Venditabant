package venditabant::Controller::Pricelists;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw { decode_json };

sub load_list_heads ($self) {

    $self->render_later;

    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    $self->pricelists->load_list_heads($companies_pkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub upsert_head ($self) {

    $self->render_later;
    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $json_hash = decode_json ($self->req->body);
    $self->pricelists->upsert_head($companies_pkey, $json_hash)->then(sub ($result) {
        $self->render(json => {'result' => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;

}

sub insert_item ($self) {
    $self->render_later;
    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $json_hash = decode_json ($self->req->body);
    $self->pricelists->insert_item($companies_pkey, $json_hash)->then(sub ($result) {
        $self->render(json => {'result' => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;
}

sub load_list_items ($self) {

    $self->render_later;

    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $pricelists_fkey = $self->param('pricelists_fkey');
    $self->pricelists->load_list_items($companies_pkey, $pricelists_fkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}
1;