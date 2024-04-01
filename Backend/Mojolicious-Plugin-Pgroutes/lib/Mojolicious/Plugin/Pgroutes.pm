package Mojolicious::Plugin::Pgroutes;
use Mojo::Base 'Mojolicious::Plugin', -signatures;

use Database;
use Database::Model;
has 'log';

our $VERSION = '0.10';

sub register ($self, $app, $config) {

  $self->log($app->log);
  $app->log->debug("Mojolicious::Plugin::Pgroutes::register start");
  eval {
    my $database = Database->new(
        pg       => $app->pg,
        log      => $app->log,
        dist_dir => $app->dist_dir,
    );

    my $tables = $database->get_tables();

    foreach my $table (@{$tables}) {
      foreach my $method (@{$table->{methods}}) {
        if ( $table->{create_endpoint} == 1 ) {
          my $route = $self->build_route($table, $method);
          my $method_name = $method->{method};
          $config->{route}->$method_name($route)->to(
              controller            => $method->{controller},
              action                => $method->{action},
              table                 => $table,
          );
        }
      }
    }
    push @{$app->routes->namespaces}, 'Database::Controller';

    $app->helper(database => sub {$database});
    $app->helper(pgmodel => sub {
      state $pgmodel = Database::Model->new(
          pg => $app->pg, log => $app->log
      )});
  };
  $app->log->error($@) if $@;

  $app->log->debug("Mojolicious::Plugin::Pgroutes::register ends");
}

sub build_route($self, $table, $method) {

  $self->log->debug("Mojolicious::Plugin::Pgroutes::build_route start");
  my $route = "";
  if (lc($table->{table_name}) eq 'v_users_companies_fkey') {
    my $test = 1;
  }
  if ($method->{type} eq 'table') {
    $route = "/" . lc($table->{table_name}) . "/" . lc($method->{action}) . "/";
    if ($method->{action} eq 'load') {
      $route .= ":" . $table->{keys}->{pk};
    }
    elsif ($method->{action} eq 'delete') {
      $route .= ":" . $table->{keys}->{pk};
    }
  } elsif ($method->{type} eq 'view') {
    if ( exists $method->{foreign_key} and $method->{foreign_key}
        and $method->{foreign_key} ne 'companies_fkey'
        and $method->{foreign_key} ne 'users_fkey') {
      $route = "/" . lc($table->{table_name}) . "/" .
          lc($method->{action}) . "/:" . $method->{foreign_key};
    } else {
      $route = "/" . lc($table->{table_name}) . "/" .
          lc($method->{action}) . "/";
    }
  }
  $self->log->debug("Mojolicious::Plugin::Pgroutes::build_route $route ends");
  return $route;
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
