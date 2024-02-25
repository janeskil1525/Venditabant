package Mojolicious::Plugin::Workflow;
use Mojo::Base 'Mojolicious::Plugin', -signatures, -async_await;

use Engine;

our $VERSION = '0.05';

sub register {
  my ($self, $app) = @_;

  my $workflow = Engine->new(
      pg     => $app->pg,
      config => $app->config,
      log    => => $app->log,
  );

  my $actions = $workflow->get_actions();
  foreach my $workflow (@{ $actions->{'actions'} }) {
    my $wf_name = $workflow->{type};
    foreach my $action (@{$workflow->{action}}) {

        my $route = "/api/" . lc($wf_name) . "/" . lc($action->{name}) . "/";
        $app->routes->post($route)->to(
            controller => 'workflows',
            action     => 'execute',
            workflow   => $wf_name,
            wf_action  => $action->{name},
        );

        my $temp = 1;


    }
    #push @{$actions->{'actions'}}, $action;
  }
  $app->helper(workflow => sub {$workflow});
}

1;
