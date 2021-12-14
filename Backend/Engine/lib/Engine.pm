package Engine;
use Mojo::Base -base, -signatures, -async_await;

use Log::Log4perl qw(:easy);
use Workflow::Factory qw(FACTORY);
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
        say $wf->id;
        $wf->execute_action($data->{action});
    }
}


1;;