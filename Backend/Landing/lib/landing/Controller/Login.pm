package landing::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub login ($self) {

  # Render template "example/welcome.html.ep" with message
  $self->render(template => 'Login/login');
}

1;
