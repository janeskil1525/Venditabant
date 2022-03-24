package Documentation::Controller::Login;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Data::Dumper;


sub showlogin {
    my $self = shift;

    $self->render(template => 'logon/logon');
}

sub login{
    my $self = shift;

    if($self->users->login($self->param('email'), $self->param('pass'))) {
        $self->session->{auth} = 1;
        return $self->redirect_to('/yancy');
    }

    $self->redirect_to($self->config->{webserver});
    $self->flash('error' => 'Wrong login/password');
}


1;