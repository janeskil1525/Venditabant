package Engine::Load::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Log::Log4perl qw(:easy);
use Workflow::Factory qw(FACTORY);

has 'config';

async sub load ($self, $workflow, $data)  {

    my $log = Log::Log4perl->get_logger();
    await $self->_init();

    my $wf;
    my $context = Workflow::Context->new(
        %{$data}
    );

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

async sub _init($self) {

    Log::Log4perl->easy_init($ERROR);
    eval {
        Log::Log4perl::init($self->config->{engine}->{conf_path});
    };
    say  $@ if $@;

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "venditabant::Helpers::Workflow::Config _init_factory Starting to configure workflow factory"
    );

    $log->debug(
        "venditabant::Helpers::Workflow::Config _init_factory Will use parser of class: " . Workflow::Config->get_factory_class( 'xml' )
    );

    FACTORY->add_config_from_file(
        persister  => $self->config->{engine}->{workflows_path} . "persister.xml",
        workflow   => $self->config->{engine}->{workflows_path} . "workflow.xml",
        action     => $self->config->{engine}->{workflows_path} . "action.xml",
        # condition  => $self->config->{engine}->{workflows_path} . "condition.xml",
        # validator  => $self->config->{engine}->{workflows_path} . "validator.xml",
    );

    $log->debug(
        "venditabant::Helpers::Workflow::Config _init_factory Finished configuring workflow factory"
    );
}

1;