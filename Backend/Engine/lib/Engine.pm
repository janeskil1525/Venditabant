package Engine;
use Mojo::Base -base, -signatures, -async_await;

use Workflow::Factory qw(FACTORY);
use Workflow::State;
use Data::Dumper;
use Syntax::Operator::Matches qw( matches mismatches );
use Types::Standard qw( Str Int Enum ArrayRef Object );

our $VERSION = '0.16';

use Engine::Load::Workflow;
use Engine::Load::DataPrecheck;
use Engine::Load::Transit;
use Engine::Load::Mappings;
use Engine::Model::Transit;
use Engine::Config::Configuration;

has 'pg';
has 'config';
has 'context';
has 'log';

async sub execute  {
    my ($self, $workflow, $data) = @_;

    $data = Engine::Load::DataPrecheck->new(
        pg => $self->pg,
        log => $self->log,
    )->precheck(
        $workflow, $data
    );

    if(!exists $data->{error}) {
        my $wf = Engine::Load::Workflow->new(
            pg     => $self->pg,
            config => $self->config,
            log    => $self->log,
        )->load (
            $workflow, $data
        );

        foreach my $action (@{$data->{actions}}) {
            my @avail = $wf->get_current_actions();
            my $avail =  \@avail;
            if ($action matches $avail) {
                if((!$wf->context->param('context_set')) or ($wf->context->param('context_set') == 0)) {
                    $wf->context(Workflow::Context->new(
                        %{ $data }
                    ));
                }
                $data = await Engine::Load::Mappings->new(
                    pg => $self->pg
                )->mappings(
                    $workflow, $action, $data
                );

                if(exists $data->{mappings}) {
                    $wf->context->param(mappings => $data->{mappings});
                }
                $wf->execute_action($action);
            }
            $self->context($wf->context());
        }
    } else {
        say Dumper($data->{error});
    }
}

async sub auto_transits ($self) {
    # Engine::Load::Transit;

    my $items = await Engine::Load::Transit->new(
        pg => $self->pg
    )->auto_transit();

    foreach my $item (@{$items}) {
        foreach my $transit (@{$item->{data}}) {
            foreach my $activity (@{$item->{activity}}) {

                my $data;
                my @keys = keys %{$transit};
                foreach my $key (@keys) {
                    $data->{$key} = $transit->{$key}
                }

                $data->{actions} = $activity;

                $data = Engine::Load::DataPrecheck->new(
                    pg => $self->pg,
                    log => $self->log,
                )->precheck(
                    $item->{workflow}->{workflow}, $data
                );

                my $wf = Engine::Load::Workflow->new(
                    pg     => $self->pg,
                    config => $self->config,
                    log    => $self->log,
                )->load (
                    $item->{workflow}->{workflow}, $data
                );
                my @avail = $wf->get_current_actions();
                my $avail = \@avail;
                if ($activity matches $avail) {
                    $data = await Engine::Load::Mappings->new(
                        pg => $self->pg
                    )->mappings(
                        $item->{workflow}->{workflow}, $activity, $data
                    );

                    $wf->context->param(history => $data->{history});
                    if(exists $data->{mappings}) {
                        $wf->context->param(mappings => $data->{mappings});
                    }
                    $wf->execute_action($activity);
                }
            }
        }
    }
}

sub get_actions($self) {

    my $config = Engine::Config::Configuration->new(pg => $self->pg);

    my $actions = $config->get_actions();

    return $actions;
}

1;;