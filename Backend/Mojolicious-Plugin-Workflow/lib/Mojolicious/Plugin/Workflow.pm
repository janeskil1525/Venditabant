package Mojolicious::Plugin::Workflow;
use Mojo::Base 'Mojolicious::Plugin', -signatures;

use Engine;

our $VERSION = '0.07';

sub register($self, $app, $config) {

    my $engine = Engine->new(
      pg     => $app->pg,
      config => $app->config,
      log    => => $app->log,
    );

    my $actions = $engine->get_actions();
    foreach my $workflow (@{$actions->{'actions'}}) {
        my $wf_name = $workflow->{type};
        foreach my $action (@{$workflow->{action}}) {
            my $route = "/" . lc($wf_name) . "/" . lc($action->{name}) . "/";
            $config->{route}->post($route)->to(
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
    $app->helper(workflow => sub {$engine});
}

1;
