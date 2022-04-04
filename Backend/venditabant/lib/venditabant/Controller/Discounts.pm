package venditabant::Controller::Discounts;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {decode_json};

use Customers;

sub save_stockitem_discount($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $data->{discount} = decode_json ($self->req->body);

    $data->{workflow_id} = Customers->new(
        pg => $self->app->pg
    )->load_workflow_id(
        $data->{discount}->{customers_fkey}
    );
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;
    push @{$data->{actions}}, 'save_stockitemdiscount';

    eval {
        $self->workflow->execute(
            'customer_simple', $data
        );
        $self->render(json => { result => 'success'});
    };

    $self->render(json => { result => 'failure', error => $@}) if $@;

}

sub load_list_stockitem_discount($self) {
    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $customers_fkey = $self->param('customers_fkey');
    $self->customers->load_list_stockitem_discount_p (
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

    my $data->{discount} = decode_json ($self->req->body);

    $data->{workflow_id} = Customers->new(
        pg => $self->app->pg
    )->load_workflow_id(
        $data->{discount}->{customers_fkey}
    );
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;
    push @{$data->{actions}}, 'save_productgroupdiscount';

    eval {
        $self->workflow->execute(
            'customer_simple', $data
        );
        $self->render(json => { result => 'success'});
    };

    $self->render(json => { result => 'failure', error => $@}) if $@;
}

sub load_list_productgroups_discount($self) {
    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $customers_fkey = $self->param('customers_fkey');
    $self->customers->load_list_productgroups_discount_p (
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

    my $data->{discount} = decode_json ($self->req->body);
    $data->{workflow_id} = Customers->new(
        pg => $self->app->pg
    )->load_workflow_id(
        $data->{discount}->{customers_fkey}
    );
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;
    push @{$data->{actions}}, 'save_discountgeneral';

    eval {
        $self->workflow->execute(
            'customer_simple', $data
        );
        $self->render(json => { result => 'success'});
    };

    $self->render(json => { result => 'failure', error => $@}) if $@;
}

sub load_list_general_discount($self) {
    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $customers_fkey = $self->param('customers_fkey');

    $self->customers->load_list_general_discount_p (
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
    my $customers_fkey = $self->param('customers_fkey');

    my $data->{workflow_id} = Customers->new(
        pg => $self->app->pg
    )->load_workflow_id(
        $customers_fkey
    );
    $data->{discount}->{customer_discount_pkey} = $customer_discount_pkey;
    $data->{discount}->{customers_fkey} = $customers_fkey;
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;

    push @{$data->{actions}}, 'delete_discountgeneral';

    eval {
        $self->workflow->execute(
            'customer_simple', $data
        );
        $self->render(json => { result => 'success'});
    };

    $self->render(json => { result => 'failure', error => $@}) if $@;
}
1;