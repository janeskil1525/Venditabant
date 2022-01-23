package Engine;
use Mojo::Base -base, -signatures, -async_await;

use Log::Log4perl qw(:easy);
use Workflow::Factory qw(FACTORY);
use Workflow::State;
use Data::Dumper;

our $VERSION = '0.07';

use Engine::Load::Workflow;
use Engine::Load::DataPrecheck;
use Engine::Load::Transit;
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
            if ($action ~~ @avail) {
                if((!$wf->context->param('context_set')) or ($wf->context->param('context_set') == 0)) {
                    $wf->context(Workflow::Context->new(
                        %{ $data }
                    ));
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
            my $data;
            $data->{workflow_id} = $transit->{workflow_id};
            $data->{invoice_pkey} = $transit->{invoice_fkey};
            $data->{users_pkey} = $transit->{users_fkey};
            $data->{companies_pkey} = $transit->{companies_fkey};

            my $wf = await Engine::Load::Workflow->new(
                pg     => $self->pg,
                config => $self->config,
            )->load (
                $item->{workflow}->{workflow}, $data
            );
            my @avail = $wf->get_current_actions();
            if ($item->{activity} ~~ @avail) {
                $wf->execute_action($item->{activity});
            }
        }
    }
}
1;;