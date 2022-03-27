package Mojolicious::Plugin::Workflow;
use Mojo::Base 'Mojolicious::Plugin';

use Engine;

our $VERSION = '0.04';

sub register {
  my ($self, $app) = @_;

  my $workflow = Engine->new(
      pg => $app->pg,
      config => $app->config
  );

  $app->helper(workflow => sub {$workflow});
}

1;
