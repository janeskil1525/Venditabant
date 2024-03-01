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
    $data->{workflow}->{workflow_relation} = 'workflow_companies';
    $data->{workflow}->{workflow_relation_key} = 'companies_fkey';
    $data->{workflow}->{workflow_origin_key} = 'companies_pkey';

    say Dumper($data);
    $self->workflow->execute(
        $data->{workflow}->{workflow} , $data
    );
    my $companies_fkey = $self->workflow->context->param('companies_fkey');

    my $users_fkey = 0;
    if ($companies_fkey > 0) {
        $data->{workflow}->{workflow} = 'Users';
        $data->{workflow}->{workflow_relation} = 'workflow_users';
        $data->{workflow}->{workflow_relation_key} = 'users_fkey';
        $data->{workflow}->{workflow_origin_key} = 'users_pkey';
        $data->{data}->{companies_fkey} = $companies_fkey;

        undef @{$data->{actions}};
        push @{$data->{actions}}, 'create_user';

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