package venditabant::Controller::Mobilelist;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {from_json};


sub load_list_mobile ($self) {

    $self->render_later;
    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    my $customer_addresses_pkey = $self->param('customer_addresses_pkey');
    my $customers_fkey = $self->param('customers_fkey');

    $self->mobilelist->load_list_mobile_p($companies_pkey, $customers_fkey, $customer_addresses_pkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load_list_mobile_nocust ($self) {

    say "load_list_mobile_nocust";
    $self->render_later;
    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    $self->mobilelist->load_list_mobile_nocust_p($companies_pkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}
1;