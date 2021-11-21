package venditabant::Controller::Discounts;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {decode_json};

sub save_stockitem_discount($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $json_hash = decode_json ($self->req->body);
    $self->discounts->save_stockitem_discount($companies_pkey, $users_pkey, $json_hash)->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;
}

sub load_list_stockitem_discount($self) {
    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $customers_fkey = $self->param('customers_fkey');
    $self->discounts->load_list_stockitem_discount (
        $companies_pkey, $users_pkey, $customers_fkey
    )->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub save_productgroups_discount($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $json_hash = decode_json ($self->req->body);
    $self->discounts->save_productgroups_discount($companies_pkey, $users_pkey, $json_hash)->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;
}

sub load_list_productgroups_discount($self) {
    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $customers_fkey = $self->param('customers_fkey');
    $self->discounts->load_list_productgroups_discount (
        $companies_pkey, $users_pkey, $customers_fkey
    )->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub save_general_discount($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $json_hash = decode_json ($self->req->body);
    $self->discounts->save_general_discount($companies_pkey, $users_pkey, $json_hash)->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;
}

sub load_list_general_discount($self) {
    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $customers_fkey = $self->param('customers_fkey');

    $self->discounts->load_list_general_discount (
        $companies_pkey, $users_pkey, $customers_fkey
    )->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub delete_general_discount($self) {
    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $customer_discount_pkey = $self->param('customer_discount_pkey');

    $self->discounts->delete_general_discount (
        $companies_pkey, $users_pkey, $customer_discount_pkey
    )->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}
1;