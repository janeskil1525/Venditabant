package Mojolicious::Plugin::Workflow;
use Mojo::Base 'Mojolicious::Plugin', -signatures, -async_await;

use Engine;

our $VERSION = '0.05';

has 'route';

sub register {
  my ($self, $app, $config) = @_;


  my $workflow = Engine->new(
      pg     => $app->pg,
      config => $app->config,
      log    => => $app->log,
  );

    $self->init($workflow, $config->{route});
  $app->helper(workflow => sub {$workflow});
}

sub init($self, $engine, $routen) {

    my $actions = $engine->get_actions();
    foreach my $workflow (@{$actions->{'actions'}}) {
        my $wf_name = $workflow->{type};
        foreach my $action (@{$workflow->{action}}) {

            my $route = "/" . lc($wf_name) . "/" . lc($action->{name}) . "/";
            $routen->post($route)->to(
                controller            => 'workflows',
                action                => 'execute',
                workflow              => $wf_name,
                wf_action             => $action->{name},
                workflow_relation     => $workflow->{config}->{workflow_relation},
                workflow_relation_key => $workflow->{config}->{workflow_relation_key},
                workflow_origin_key   => $workflow->{config}->{workflow_origin_key},
            );
        }
    }
}
1;
