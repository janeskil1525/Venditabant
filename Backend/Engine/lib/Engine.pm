package Engine;
use Mojo::Base -base, -signatures, -async_await;

use Log::Log4perl qw(:easy);
use Workflow::Factory qw(FACTORY);
use Workflow::State;
use Data::Dumper;

use Engine::Load::Workflow;
use Engine::Load::DataPrecheck;

has 'pg';
has 'config';
has 'workflow';

async sub execute  {
    my ($self, $workflow, $data) = @_;


    $data = await Engine::Load::DataPrecheck->new(
        pg => $self->pg
    )->precheck(
        $workflow, $data
    );

    # my $prelude = Engine
    if(!exists $data->{error}) {
        my $wf = await Engine::Load::Workflow->new(
            pg     => $self->pg,
            config => $self->config,
        )->load (
            $workflow, $data
        );

        foreach my $action (@{$data->{actions}}) {
            $wf->execute_action($action);
        }
    }
}


1;;