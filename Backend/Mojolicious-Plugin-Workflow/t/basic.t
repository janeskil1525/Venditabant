use Mojo::Base -strict;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;
use Mojo::Pg;



my $pg = Mojo::Pg->new->dsn(
    "dbi:Pg:dbname=Venditabant;host=database;port=15432;user=postgres;password=PV58nova64"
);

plugin 'Config' => { path => "Log/LogFile.log" };
plugin 'Workflow' => {pg => $pg};

get '/' => sub {
  my $c = shift;
  $c->render(text => 'Hello Mojo!');
};

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)->content_is('Hello Mojo!');

done_testing();
