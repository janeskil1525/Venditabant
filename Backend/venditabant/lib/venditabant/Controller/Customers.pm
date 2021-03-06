package venditabant::Controller::Customers;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {decode_json};
use Customers;

sub save_customer ($self) {

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $data->{customer} = decode_json ($self->req->body);
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;
    if(exists $data->{customer}->{customers_pkey} and $data->{customer}->{customers_pkey} > 0) {
        $data->{workflow_id} = Customers->new(
            pg => $self->app->pg
        )->load_workflow_id(
            $data->{customer}->{customers_pkey}
        );
        push @{$data->{actions}}, 'update_customer';
    } else {
        $data->{customer}->{customer} = Customers->new(
            pg => $self->app->pg
        )->get_new_cust_id($companies_pkey, $users_pkey)
            unless $data->{customer}->{customer};
        push @{$data->{actions}}, 'create_customer';
    }

    eval {
        $self->workflow->execute(
            'customer_simple', $data
        );
        $self->render(json => { result => 'success'});
    };

    $self->render(json => { result => 'failure', error => $@}) if $@;
}

sub load_list ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    $self->customers->load_list($companies_pkey, $users_pkey)->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

1;