package venditabant::Controller::Workflows;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw { decode_json};

has 'wf_action';
has 'workflow';

sub export ($self) {
    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    $self->workflows->export( )->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;

}

sub load_list ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    $self->workflows->load_list($companies_pkey, $users_pkey)->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub save_workflow($self) {
    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $json_hash = decode_json ($self->req->body);
    $self->workflows->upsert($companies_pkey, $users_pkey, $json_hash)->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;
}

sub load_workflow($self) {

    $self->render_later;

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $workflows_fkey = $self->param('workflows_fkey');
    my $workflow_type = $self->param('workflow_type');

    $self->workflows->load_workflow(
        $companies_pkey, $users_pkey, $workflows_fkey, $workflow_type
    )->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;

}

sub execute($self) {

    $self->render_later;

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $data->{data} = decode_json ($self->req->body);
    $data->{users_fkey} = $users_pkey;
    $data->{companies_fkey} = $companies_pkey;
    $data->{workflow_id} = 0;

    push @{$data->{actions}}, "$self->stash('wf_action')";
    $data->{workflow}->{workflow} = $self->stash('workflow');
    $data->{workflow}->{workflow_relation} = $self->stash('workflow_relation');
    $data->{workflow}->{workflow_relation_key} = $self->stash('workflow_relation_key');
    $data->{workflow}->{workflow_origin_key} = $self->stash('workflow_origin_key');

    $self->engine->execute(
        $data->{workflow}->{workflow}, $data
    )->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {
        $self->render(json => {'result' => 'failed', data => $err});
    })->wait();
}
1;