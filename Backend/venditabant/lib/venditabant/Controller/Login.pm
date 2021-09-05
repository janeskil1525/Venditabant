package venditabant::Controller::Login;
use Mojo::Base 'Mojolicious::Controller', -signatures;


sub login_user ($self) {

	say 'login_user';

	$self->render(json => {'login' => "success"});
}

1;
