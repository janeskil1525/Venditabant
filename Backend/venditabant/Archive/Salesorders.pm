package venditabant::Controller::Salesorders;
use Mojo::Base 'Mojolicious::Controller', -signatures, -async_await;

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
    my $customer_addresses_pkey = $self->param('customer_addresses_pkey');

    my $salesorders_pkey = $self->salesorders->get_open_so_pkey(
        $companies_pkey, $users_pkey, $customer_addresses_pkey
    );

    if($salesorders_pkey == 0) {
        my $data->{customer_addresses_pkey} = $customer_addresses_pkey;
        $data->{companies_fkey} = $companies_pkey;
        $data->{users_fkey} = $users_pkey;
        push @{$data->{actions}}, 'create_order';

        eval {
            # say Dumper($self->workflow);
            $self->workflow->execute(
                'salesorder_simple', $data
            );
        };
        say $@ if $@;
        $salesorders_pkey = $self->salesorders->get_open_so_pkey(
            $companies_pkey, $users_pkey, $customer_addresses_pkey
        );
    }

    $self->render(json => {salesorders_pkey => $salesorders_pkey, result => 'success'});
}

sub save_item ($self) {

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $data = decode_json ($self->req->body);
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;

    push @{$data->{actions}}, 'additem_to_order';
    eval {
        $self->workflow->execute(
            'salesorder_simple', $data
        );
        $self->render(json => { result => 'success'});
    };
    $self->render(json => { result => 'failure', error => $@}) if $@;

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

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $data = decode_json ($self->req->body);
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;

    push @{$data->{actions}}, 'close_order';
    eval {
        $self->workflow->execute(
            'salesorder_simple', $data
        );
        $self->render(json => { result => 'success'});
    };
    $self->render(json => { result => 'failure', error => $@}) if $@;

}
1;