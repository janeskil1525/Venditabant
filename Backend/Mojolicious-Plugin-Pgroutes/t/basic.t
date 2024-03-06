use Mojo::Base -strict, -signatures;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;
use Mojo::Pg;
use Mojo::Log;
use File::Share;
use Mojo::File;
use Mojo::Home;

my $log = Mojo::Log->new(
    path => '/home/jan/IdeaProjects/Venditabant/Backend/venditabant/Log/mojo.log',
    level => 'debug'
);

my $pg = Mojo::Pg->new->dsn(
    "dbi:Pg:dbname=Venditabant;host=database;port=15432;user=postgres;password=PV58nova64"
);

helper log => sub ($c) {
  return $log
};

helper pg => sub ($c) {
  return $pg;
};

helper dist_dir => sub($c) {
  return Mojo::File->new(
      '/home/jan/IdeaProjects/Venditabant/Backend/venditabant/share/'
  );
};

$ENV{VENDITABANT_HOME} = '/home/jan/IdeaProjects/Venditabant/Backend/venditabant/'
    unless $ENV{VENDITABANT_HOME};


helper home => sub($c) {
  Mojo::Home->new($ENV{VENDITABANT_HOME});
};

plugin 'Pgroutes';

get '/' => sub {
  my $c = shift;
  $c->render(text => 'Hello Mojo!');
};

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)->content_is('Hello Mojo!');

done_testing();
