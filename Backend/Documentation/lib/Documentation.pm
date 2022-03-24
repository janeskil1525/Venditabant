package Documentation;
use Mojo::Base 'Mojolicious', -signatures;

use Mojo::Pg;
use Mojo::JSON qw{encode_json from_json};
use Mojo::File;
use File::Share;

use Data::Dumper;

$ENV{ DOCUMENTATION_HOME } = '/home/jan/Project/Venditabant/Backend/Documentation/'
    unless  $ENV{DOCUMENTATION_HOME};

has dist_dir => sub {
  return Mojo::File->new(
      File::Share::dist_dir('Documentation')
  );
};

has home => sub {
  Mojo::Home->new($ENV{DOCUMENTATION_HOME});
};

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('Config');

  # Configure the application
  $self->secrets($config->{secrets});

  $self->renderer->paths([
      $self->dist_dir->child('templates'),
  ]);
  $self->static->paths([
      $self->dist_dir->child('public'),
  ]);

  $self->helper(pg => sub {state $pg = Mojo::Pg->new->dsn(shift->config('pg'))});
  say "Documentation " . $self->pg->db->query('select version() as version')->hash->{version};
  $self->pg->migrations->name(
      'documentation'
  )->from_file(
      $self->dist_dir->child(
          'migrations/documentation.sql'
      )
  )->migrate(1);

  $self->helper(users => sub { state $users = Documentation::Model::Users->new(pg => shift->pg)});

  my $schema = from_json(
      Mojo::File->new(
          $self->dist_dir->child('schema/documentation.json')
      )->slurp
  ) ;
  $self->log->path($self->home() . $self->config('log'));

  my $auth_yancy = $self->routes->under( '/yancy', sub {
    my ( $c ) = @_;

    return 1 if ($c->session('auth') // '') eq '1';
    $c->redirect_to('/');
    return undef;
  } );

  $self->plugin(
      'Yancy' => {
          #route                 => $auth_yancy,
          backend               => { Pg => $self->pg },
          schema                => $schema,
          read_schema           => 0,
          editor => {
              require_user => undef,
              return_to     => '/yancy'
          },
          file                  => {

          },
      }
  );

  $self->yancy->plugin( 'Auth' => {
      plugins => [
          [
              'Password',
              {
                  schema          => 'users',
                  username_field  => 'userid',
                  password_field  => 'passwd',
                  password_digest => {
                      type => 'SHA-256'
                  },

                  # allow_register        => 1,
              },
          ],
      ],
  } );


  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/documentation')->to('login#showlogin');
    $r->get('/*pathtodoc')->to(
        id         => 'index',
        controller => 'yancy',
        action     => 'get',
        schema     => 'documentation',
        template   => 'pages/pages',
    );
  $r->post('/login')->to('login#login');
}

1;
