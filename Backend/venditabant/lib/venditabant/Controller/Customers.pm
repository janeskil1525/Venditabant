package venditabant::Controller::Customers;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;
use Mojo::JSON qw {decode_json};

sub save_customer ($self) {

    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );

    say "1";
    my $data->{customer} = decode_json ($self->req->body);
    $data->{companies_fkey} = $companies_pkey;
    $data->{users_fkey} = $users_pkey;
    if(exists $data->{customer}->{customers_pkey} and $data->{customer}->{customers_pkey} > 0) {
        push @{$data->{actions}}, 'update_customer';
    } else {
        push @{$data->{actions}}, 'create_customer';
    }
    say "2";
    say Dumper($data);
    eval {
        $self->workflow->execute(
            'customer_simple', $data
        );
        say "3";
        $self->render(json => { result => 'success'});
    };
    say "4";
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