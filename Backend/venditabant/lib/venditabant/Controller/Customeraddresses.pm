package venditabant::Controller::Customeraddresses;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {from_json};

sub save_address ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $json_hash = from_json ($self->req->body);
    $self->customeraddress->upsert($companies_pkey, $users_pkey, $json_hash)->then(sub ($result) {
        $self->render(json => {'result' => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;

}

sub load_list ($self) {

    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    $self->customeraddress->load_list($companies_pkey)->then(sub ($result) {

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
    $self->customeraddress->load_invoice_address_p($companies_pkey, $users_pkey, $customers_fkey)->then(sub ($result) {
        say Dumper($result);
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}
1;