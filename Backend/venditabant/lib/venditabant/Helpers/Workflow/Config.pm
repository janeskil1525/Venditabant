package venditabant::Helpers::Workflow::Config;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Log::Any          qw( $log );
use Log::Any::Adapter;

use Workflow::Factory qw(FACTORY);
use Data::Dumper;
use Workflow::Config;

has 'pg';

async sub load_config($self, $workflow) {

    Log::Any::Adapter->set( 'File', '/home/jan/Project/Venditabant/Backend/venditabant/Log/workflow.log');
    my $result;
    my $config = await $self->_load_config($workflow);
    my %temp;
    my $hash = \%temp;

    foreach my $conf (@{ $config }) {
        $hash->{$conf->{workflow_type}} = $conf->{workflow};
    }

    await $self->_init_factory($hash);
    return 1;
}

async sub _init_factory ($self, $config){

    $self->capture_log(
        $self->pg, 'venditabant::Helpers::Workflow::Config', '_init_factory',"Starting to configure workflow factory"
    );

    $self->capture_log(
        $self->pg, 'venditabant::Helpers::Workflow::Config', '_init_factory',"Will use parser of class: " . Workflow::Config->get_factory_class( 'xml' )
    );
say Dumper($config);
    FACTORY->add_config(
        %{ $config }
    );

    $self->capture_log(
        $self->pg, 'venditabant::Helpers::Workflow::Config', '_init_factory',"Finished configuring workflow factory"
    );
}

async sub _load_config($self, $workflow) {

   my $stmt = qq{
        SELECT workflow_type, workflow_items.workflow as workflow
            FROM workflows, workflow_items
        WHERE workflows_fkey = workflows_pkey AND workflows.workflow = ?
   };

    my $result = $self->pg->db->query($stmt,($workflow));

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}
1;