package venditabant;
use Mojo::Base 'Mojolicious', -signatures;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  $self->plugin('qooxdoo',{
      prefix => '/',
      path => 'v1/jsonrpc/login',
      controller => 'Login'
  });
  $self->plugin('SecureCORS');
  $self->routes->to('cors.credentials'=>1);

  # $self->hook(after_dispatch => sub {
  #   my $c = shift;
  #   $c->res->headers->header('Access-Control-Allow-Origin' => '*');
  #   $c->res->headers->access_control_allow_origin('*');
  #   $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, OPTIONS, POST, DELETE, PUT');
  #   $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type' => 'application/x-www-form-urlencoded');
  #
  # });
  # Router
  #my $r = $self->routes;
  my $r = $self->routes->under_strict_cors('/');
  # Normal route to controller
  $r->get('/')->to('Example#welcome');

   $r->cors('/v1/login/')->to(
        'cors.methods'      => 'GET, POST',
  #     # 'cors.origin'       => 'http://localhost:8080',
  #    #  'cors.credentials'  => 1,
   );

  $r->post('/v1/login/',
      headers => { 'Content-Type' => 'application/json' }
  )->to('login#login_user',
      'cors.origin'       => 'http://localhost:8080',
      'cors.credentials'  => 1,
  );

  $r->any('/RpcService') -> to(
      controller => 'Login',
      action => 'dispatch',
  );
}

1;
