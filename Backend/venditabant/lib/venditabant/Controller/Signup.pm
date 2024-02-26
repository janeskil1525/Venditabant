package venditabant::Controller::Signup;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw{decode_json};
#use venditabant::Helpers::Signup::Signup;
#use Sentinel::Helpers::Sentinelsender;

use Data::Dumper;

sub signup_company ($self) {

    #self->render_later();

    my $data->{data} = decode_json ($self->req->body);
    push @{$data->{actions}}, 'create_company';


    $data->{workflow}->{workflow} = 'Companies';
    $data->{workflow}->{workflow_relation} = 'workflow_company';
    $data->{workflow}->{workflow_relation_key} = 'companies_fkey';
    $data->{workflow}->{workflow_origin_key} = 'companies_pkey';

    say Dumper($data);
    $self->workflow->execute(
        $data->{workflow}->{workflow} , $data
    );
    my $companies_fkey = $self->workflow->context('companies_fkey');

    my $users_fkey = 0;
    if ($companies_fkey > 0) {
        $data->{workflow}->{workflow} = 'Users';
        $data->{workflow}->{wf_action} = 'create_user';
        $data->{workflow}->{workflow_relation} = 'workflow_users';
        $data->{workflow}->{workflow_relation_key} = 'users_fkey';
        $data->{workflow}->{workflow_origin_key} = 'users_pkey';
        $data->{company}->{companies_fkey} = $companies_fkey;
        $data->{user} = $data->{company};

        $#$data->{actions} = -1;
        push @{$data->{actions}}, 'create_user';
        say Dumper($data);
        $self->workflow->execute(
            $data->{workflow}->{workflow} , $data
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