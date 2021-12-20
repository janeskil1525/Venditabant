package venditabant::Controller::Salesorders;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {decode_json};


sub load_salesorder_items_list ($self) {

    $self->render_later;

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $salesorders_fkey = $self->param('salesorders_fkey');
    $self->salesorders->load_salesorder_items_list(
        $companies_pkey, $users_pkey, $salesorders_fkey
    )->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load_salesorder ($self) {

    $self->render_later;

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $salesorders_pkey = $self->param('salesorders_pkey');
    $self->salesorders->load_salesorder($companies_pkey, $users_pkey, $salesorders_pkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load_salesorder_list ($self) {

    $self->render_later;

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $open = $self->param('open');
    $self->salesorders->load_salesorder_list($companies_pkey, $users_pkey, $open)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub item_save ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $json_hash = decode_json ($self->req->body);

    $self->salesorders->item_upsert(
        $companies_pkey, $users_pkey, $json_hash
    )->then(sub ($result) {
        $self->render(json => {'result' => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;

}

sub load_salesorder_pkey ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $json_hash = decode_json ($self->req->body);

    my $salesorders_pkey = await $self->salesorders->get_open_so_pkey(
        $companies_pkey, $users_pkey, $json_hash->{customer_addresses_pkey}
    );

    if($salesorders_pkey == 0) {
        my $data->{customer_addresses_pkey} = $json_hash->{customer_addresses_pkey};
        $data->{companies_fkey} = $companies_pkey;
        $data->{users_fkey} = $users_pkey;
        push @{$data->{actions}}, 'create_order';
        $self->workflow(
            'salesorder_simple', $data
        );
        $salesorders_pkey = await $self->salesorders->get_open_so_pkey(
            $companies_pkey, $users_pkey, $json_hash->{customer_addresses_pkey}
        );
    }

    $self->render(json => {'result' => {salesorders_pkey => $salesorders_pkey}});
}

sub save_salesorder ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $json_hash = decode_json ($self->req->body);

    $self->salesorders->upsert(
        $companies_pkey, $users_pkey, $json_hash
    )->then(sub ($result) {
        $self->render(json => {'result' => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;

}

sub close_salesorder ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $json_hash = decode_json ($self->req->body);

    $self->salesorders->close(
        $companies_pkey, $users_pkey, $json_hash
    )->then(sub ($result) {
        $self->render(json => {'result' => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;

}
1;