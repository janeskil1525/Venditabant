package Mojolicious::Plugin::Workflow;
use Mojo::Base 'Mojolicious::Plugin', -signatures;

use Engine;

our $VERSION = '0.07';

sub register($self, $app, $config) {

    $app->log->debug("Mojolicious::Plugin::Workflow::register start");
    eval {
        my $engine = Engine->new(
            pg     => $app->pg,
            config => $app->config,
            log    => $app->log,
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

        $config->{route}->get('/workflows/export/')->to('workflows#export');
        $config->{route}->get('/workflows/load_list/')->to('workflows#load_list');
        $config->{route}->put('/workflows/save/')->to('workflows#save_workflow');
        $config->{route}->get('/workflows/load/:workflows_fkey/:workflow_type')->to('workflows#load_workflow');
        $config->{route}->get('/workflows/history/list/:hist_type/:hist_key')->to('history#load_list');

        push @{$app->routes->namespaces}, 'Engine::Controller';
        $app->helper(engine => sub {$engine});
    };
    $app->log->error($@) if $@;

    $app->log->debug("Mojolicious::Plugin::Workflow::register ends");
}

1;
