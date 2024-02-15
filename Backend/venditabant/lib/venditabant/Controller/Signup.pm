package venditabant::Controller::Signup;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw{decode_json};
#use venditabant::Helpers::Signup::Signup;
#use Sentinel::Helpers::Sentinelsender;

use Data::Dumper;

sub signup_company ($self) {

    $self->render_later();

    my $data->{company} = decode_json ($self->req->body);
    push @{$data->{actions}}, 'create_company';

    say Dumper($data);
    $self->workflow->execute(
        'Companies', $data
    );
    my $companies_fkey = $self->workflow->context('companies_fkey');

    $self->render(json => { result => 'success'});
    my $users_fkey = 0;
    if ($companies_fkey > 0) {
        $data->{company}->{companies_fkey} = $companies_fkey;
        $data->{user} = $data->{company};
        $#$data->{actions} = -1;
        push @{$data->{actions}}, 'create_user';

        say Dumper($data);
        $self->workflow->execute(
            'Users', $data
        );
        $users_fkey = $self->workflow->context('users_fkey');
    }

    unless ($companies_fkey > 0 and $users_fkey > 0) {
        $self->render(json => { result => 'failure', error => 'Signup failed'});
    } else {
        $self->render(json => { result => 'success'});
        say 'Success';
    }
}

1;