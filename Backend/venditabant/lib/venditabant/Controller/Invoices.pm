package venditabant::Controller::Invoices;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {from_json};


sub load_invoice_list ($self) {
    $self->render_later;

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $open = $self->param('open');
    $self->invoices->load_invoice_list($companies_pkey, $users_pkey, $open)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load_invoice ($self) {

    $self->render_later;

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $invoice_fkey = $self->param('invoice_fkey');
    $self->invoices->load_invoice($companies_pkey, $users_pkey, $invoice_fkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load_invoice_items_list ($self) {

    $self->render_later;

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $invoice_fkey= $self->param('invoice_fkey');
    $self->invoices->load_invoice_items_list(
        $companies_pkey, $users_pkey, $invoice_fkey
    )->then(sub ($result) {
        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}



1;