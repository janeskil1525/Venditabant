package venditabant::Controller::Companies;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {decode_json};

use Companies;

sub save_company ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $data->{company} = decode_json ($self->req->body);
    $data->{users_fkey} = $users_pkey;
    $data->{companies_fkey} = $companies_pkey;

    $data->{workflow_id} = Companies->new(
        pg => $self->app->pg
    )->load_workflow_id(
        $companies_pkey
    );
    push @{$data->{actions}}, 'update_company';

    say Dumper($data);

    eval {
        $self->workflow->execute(
            'Companies', $data
        );
        $self->render(json => { result => 'success'});
    };

    $self->render(json => { result => 'failure', error => $@}) if $@;

}

sub load_list ($self) {

    $self->render_later;
    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    $self->companies->load_list()->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')

    );
    $self->companies->load_p($companies_pkey, $users_pkey)->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {
        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

1;