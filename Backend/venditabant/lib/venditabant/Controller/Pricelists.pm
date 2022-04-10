package venditabant::Controller::Pricelists;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw { decode_json };
use Data::Dumper;

use Pricelists;

sub load_list_heads ($self) {

    $self->render_later;

    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    $self->pricelists->load_list_heads_p($companies_pkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub upsert_head ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $data->{pricelist} = decode_json ($self->req->body);
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;

    my $result = $self->_upsert_head($data);
    $self->render(json => { result => $result});

}

sub _upsert_head($self, $data_in) {

    my $data = $data_in;
    push @{$data->{actions}}, 'create_pricelist';

    my $result = '';
    eval {
        $self->workflow->execute(
            'pricelist_simple', $data
        );
        $result = 'success';
    };
    $result = $@ if $@;

    return $result
}

sub _get_workflow_id($self, $data) {
    my $workflow_id = Pricelists->new(
        pg => $self->app->pg
    )->load_workflow_id(
        $data->{pricelist}->{pricelists_fkey}
    );
    return $workflow_id ? $workflow_id : 0;
}

sub insert_item ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $data->{pricelist} = decode_json ($self->req->body);
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;
    $data->{workflow_id} = $self->_get_workflow_id($data);

    if(!$data->{workflow_id} or $data->{workflow_id} == 0) {
        my $result = $self->_upsert_head($data);
        $data->{workflow_id} = $self->_get_workflow_id($data);
    }
    push @{$data->{actions}}, 'update_pricelist';

    eval {
        $self->workflow->execute(
            'pricelist_simple', $data
        );
        $self->render(json => { result => 'success'});
    };

    $self->render(json => { result => 'failure', error => $@}) if $@;;
}

sub load_list_items ($self) {

    $self->render_later;

    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $pricelists_fkey = $self->param('pricelists_fkey');
    $self->pricelists->load_list_items_p($companies_pkey, $pricelists_fkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}
1;