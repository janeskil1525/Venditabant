package venditabant::Controller::Stockitems;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {decode_json};

use Stockitems;

sub save_stockitem ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $data->{stockitem} = decode_json ($self->req->body);
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;

    if(exists $data->{stockitem}->{stockitems_pkey} and $data->{stockitem}->{stockitems_pkey} > 0) {
        $data->{workflow_id} = Stockitems->new(
            pg => $self->app->pg
        )->load_workflow_id(
            $data->{stockitem}->{stockitems_pkey}
        );
        push @{$data->{actions}}, 'update_stockitem';
    } else {
        $data->{stockitem}->{stockitem} = Stockitems->new(
            pg => $self->app->pg
        )->get_new_stockitem_id($companies_pkey, $users_pkey)
            unless $data->{stockitem}->{stockitem};
        push @{$data->{actions}}, 'create_stockitem';
    }

    say Dumper($data);

    eval {
        $self->workflow->execute(
            'stockitem_simple', $data
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

    $self->stockitems->load_list_p($companies_pkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

1;