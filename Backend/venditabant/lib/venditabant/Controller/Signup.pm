package venditabant::Controller::Signup;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw{decode_json};
#use venditabant::Helpers::Signup::Signup;
#use Sentinel::Helpers::Sentinelsender;

use Data::Dumper;

sub signup_company ($self) {

    $self->render_later();

    my $data->{company} = decode_json ($self->req->body);
    push @{$data->{actions}}, 'signup';

    say Dumper($data);

    eval {
        $self->workflow->execute(
            'Companies', $data
        );
        $self->render(json => { result => 'success'});
    };

    $self->render(json => { result => 'failure', error => $@}) if $@;

}

1;