package Mojolicious::Plugin::Pgroutes;
use Mojo::Base 'Mojolicious::Plugin', -signatures;

use Database;
use Database::Model::Postgres;

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
      state $pgmodel = Database::Model::Postgres->new(
          pg => shift->pg, log => shift->log
      )});
  };
  $err = $@ if $@;
my $test = 1;

}

sub build_route($self, $table, $method) {

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
    if ( $method->{foreign_key} ne 'companies_fkey' and $method->{foreign_key} ne 'users_fkey') {
      $route = "/" . lc($table->{table_name}) . "/" .
          lc($method->{action}) . "/:" . $method->{foreign_key};
    } else {
      $route = "/" . lc($table->{table_name}) . "/" .
          lc($method->{action}) . "/";
    }


  }
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
