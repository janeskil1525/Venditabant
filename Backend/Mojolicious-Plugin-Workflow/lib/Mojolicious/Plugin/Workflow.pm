package Mojolicious::Plugin::Workflow;
use Mojo::Base 'Mojolicious::Plugin';

use Engine;

our $VERSION = '0.01';

sub register {
  my ($self, $app) = @_;

  my $workflow = Engine->new(
      pg => $app->pg,
      config => $app->config
  );

  $app->helper(workflow => sub {$workflow});
}

1;

=encoding utf8

=head1 NAME

Mojolicious::Plugin::Workflow - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Workflow');

  # Mojolicious::Lite
  plugin 'Workflow';

=head1 DESCRIPTION

L<Mojolicious::Plugin::Workflow> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::Workflow> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<https://mojolicious.org>.

=cut
