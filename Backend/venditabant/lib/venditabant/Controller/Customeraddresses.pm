package venditabant::Controller::Customeraddresses;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {decode_json};

use Customers;

sub save_address ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );


    my $data->{address} = decode_json ($self->req->body);
    $data->{workflow_id} = Customers->new(
        pg => $self->app->pg
    )->load_workflow_id(
        $data->{address}->{customers_fkey}
    );

    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;

    if(exists $data->{address}->{type} and $data->{address}->{type} eq 'INVOICE') {
        push @{$data->{actions}}, 'update_invoiceaddress';
    } else {
        push @{$data->{actions}}, 'update_deliveryaddress';
    }
    say Dumper($data);
    eval {
        $self->workflow->execute(
            'customer_simple', $data
        );
        $self->render(json => { result => 'success'});
    };

    $self->render(json => { result => 'failure', error => $@}) if $@;

}

sub load_delivery_address_list ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $customers_fkey = $self->param('customers_fkey');
    $self->customers->load_delivery_address_list_p($companies_pkey, $users_pkey, $customers_fkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load_delivery_address_from_customer_list ($self) {
    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $customer = $self->param('customer');
    $self->customers->load_delivery_address_from_customer_list_p(
        $companies_pkey, $users_pkey, $customer
    )->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load_delivery_address_from_company_list($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    $self->customers->load_delivery_address_from_company_list(
        $companies_pkey, $users_pkey
    )->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load_invoice_address ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $customers_fkey = $self->param('customers_fkey');
    $self->customers->load_invoice_address_p(
        $companies_pkey, $users_pkey, $customers_fkey
    )->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load_delivery_address ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $customer_addresses_pkey= $self->param('customer_addresses_pkey');
    $self->customers->load_delivery_address_p(
        $companies_pkey, $users_pkey, $customer_addresses_pkey
    )->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}
1;