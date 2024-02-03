package Engine;
use Mojo::Base -base, -signatures, -async_await;

use Log::Log4perl qw(:easy);
use Workflow::Factory qw(FACTORY);
use Workflow::State;
use Data::Dumper;
use Syntax::Operator::Matches qw( matches mismatches );
use Types::Standard qw( Str Int Enum ArrayRef Object );

our $VERSION = '0.13';

use Engine::Load::Workflow;
use Engine::Load::DataPrecheck;
use Engine::Load::Transit;
use Engine::Load::Mappings;
use Engine::Model::Transit;

has 'pg';
has 'config';

async sub execute  {
    my ($self, $workflow, $data) = @_;

    $data = await Engine::Load::DataPrecheck->new(
        pg => $self->pg
    )->precheck(
        $workflow, $data
    );

    if(!exists $data->{error}) {
        my $wf = await Engine::Load::Workflow->new(
            pg     => $self->pg,
            config => $self->config,
        )->load (
            $workflow, $data
        );

        foreach my $action (@{$data->{actions}}) {
            my @avail = $wf->get_current_actions();
            if ($action matches @avail) {
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

                $data = await Engine::Load::DataPrecheck->new(
                    pg => $self->pg
                )->precheck(
                    $item->{workflow}->{workflow}, $data
                );

                my $wf = await Engine::Load::Workflow->new(
                    pg     => $self->pg,
                    config => $self->config,
                )->load (
                    $item->{workflow}->{workflow}, $data
                );
                my @avail = $wf->get_current_actions();

                if ($activity matches @avail) {
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
1;;