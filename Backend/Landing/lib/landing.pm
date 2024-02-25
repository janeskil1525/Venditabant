package landing;
use Mojo::Base 'Mojolicious', -signatures;

use Mojo::Pg;
use Mojo::JSON qw{encode_json from_json};
use File::Share;
use Mojo::File;

use Data::Dumper;

$ENV{ LANDING_HOME } = '/home/jan/IdeaProjects/Venditabant/Backend/Landing/'
    unless $ENV{ LANDING_HOME };

has dist_dir => sub {
  return Mojo::File->new(
      File::Share::dist_dir('landing')
  );
};

has home => sub {
  Mojo::Home->new($ENV{LANDING_HOME});
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
  say "Landing " . $self->pg->db->query('select version() as version')->hash->{version};

  $self->pg->migrations->name(
      'landing'
  )->from_file(
      $self->dist_dir->child(
          'migrations/landing.sql'
      )
  )->migrate(2);

  my $schema = from_json(
      Mojo::File->new(
          $self->dist_dir->child('schema/landing.json')
      )->slurp
  );
  $self->log->path($self->home() . $self->config('log'));

  # my $auth_yancy = $self->routes->under( '/yancy', sub {
  #   my ( $c ) = @_;
  #
  #   return 1 if ($c->session('auth') // '') eq '1';
  #   $c->redirect_to('/');
  #   return undef;
  # } );

  $self->plugin(
      'Yancy' => {
          # route                 => $auth_yancy,
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
                  password_field  => 'password',
                  password_digest => {
                      type => 'SHA-256'
                  },

                  # allow_register        => 1,
              },
          ],
      ],
  } );

  $self->yancy->plugin( 'File' => {
      file_root => 'public/help',
      file_root => '/help'
  } );


  # Router
  my $r = $self->routes;
    $r->get(
        '/:pagepath'
    )->to(
        controller => 'yancy',
        action => 'get',
        schema => 'pages',
        template => 'pages/pages',
    );
  # Normal route to controller
  #$r->get('/')->to('Login#Login'  );
}

1;
