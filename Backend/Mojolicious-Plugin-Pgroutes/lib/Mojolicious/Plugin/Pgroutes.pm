package Mojolicious::Plugin::Pgroutes;
use Mojo::Base 'Mojolicious::Plugin', -signatures;

use Database;

our $VERSION = '0.01';

sub register ($self, $app, $config) {

  my $err;
  eval {
    my $database = Database->new(
        pg       => $app->pg,
        log      => $app->log,
        dist_dir => $app->dist_dir,
    );

    my $tables = $database->get_tables();

    foreach my $table (@{$tables}) {
      foreach my $action (@{$table->{action}}) {
        my $route = "/" . lc($table->{name}) . "/" . lc($action->{name}) . "/";
        $config->{route}->post($route)->to(
            controller            => 'database',
            table                 => $table,
            action                => $action->{name},
            schema                => $action->{schema},
        );
      }
    }
    push @{$app->routes->namespaces}, 'Database::Controller';

    $app->helper(database => sub {$database});
  };
  $err = $@ if $@;
my $test = 1;

}

1;

=encoding utf8

=head1 NAME

Mojolicious::Plugin::Pgroutes - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Pgroutes');

  # Mojolicious::Lite
  plugin 'Pgroutes';

=head1 DESCRIPTION

L<Mojolicious::Plugin::Pgroutes> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::Pgroutes> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<https://mojolicious.org>.

=cut
