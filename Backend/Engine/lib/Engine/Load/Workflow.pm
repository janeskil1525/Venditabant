package Engine::Load::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Engine::Config::Configuration;

use Log::Log4perl qw(:easy);
use Workflow::Factory qw(FACTORY);

has 'pg';
has 'config';

async sub load ($self, $workflow, $data)  {

    my $log = Log::Log4perl->get_logger();
    await $self->_init($workflow);

    my $wf;
    my $context = Workflow::Context->new(
        %{$data}
    );

    $data->{workflow_id} = 0 unless exists $data->{workflow_id};

    if($data->{workflow_id} > 0) {
        $wf = FACTORY->fetch_workflow( $workflow, $data->{workflow_id}, $context );
    } else {
        $wf = FACTORY->create_workflow( $workflow, $context );
    }
    if ( $wf ) {
        $log->debug( "Workflow found; current state: '", $wf->state, "'" );
    }
    return $wf;
}

async sub _init($self, $workflow) {

    Log::Log4perl->easy_init($ERROR);
    eval {
        Log::Log4perl::init($self->config->{engine}->{conf_path});
    };
    say  $@ if $@;

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Load::Workflow _init_factory Starting to configure workflow factory"
    );

    my $types = "('action', 'condition', 'persister', 'validator', 'workflow')";

    my $config = await Engine::Config::Configuration->new(
        pg => $self->pg
    )->load_config(
        $workflow, $types
    );

    FACTORY->add_config (
        %{$config}
        #persister  => $self->config->{engine}->{workflows_path} . "persister.xml",
        #workflow   => $self->config->{engine}->{workflows_path} . "workflow.xml",
        #action     => $self->config->{engine}->{workflows_path} . "action.xml",
        # condition  => $self->config->{engine}->{workflows_path} . "condition.xml",
        # validator  => $self->config->{engine}->{workflows_path} . "validator.xml",
    );

    $log->debug(
        "Engine::Load::Workflow _init_factory Finished configuring workflow factory"
    );
}

1;