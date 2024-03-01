package Engine::Workflow::Action::Base;
use Mojo::Base 'Workflow::Action', -base, -signatures;

use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Workflow::Factory qw( FACTORY );
use Workflow::Exception qw( workflow_error );
use Workflow::History;
use Engine::Model::Workflowrelation;

has 'pg';
has 'context';
has 'db';
has 'tx';
has 'data';
has 'workflow';

sub _init($self, $wf, $persister) {
    $self->pg($self->get_pg($persister));
    $self->context($wf->context);
    $self->db($self->pg->db);
    $self->tx($self->db->begin);
    $self->data($self->context->param('data'));
    $self->workflow($self->context->param('workflow'));
}

sub get_pg($self, $persister) {
    return  FACTORY->get_persister( $persister )->get_pg();
}

sub add_history($self, $wf, $action, $description, $user) {
    $wf->add_history(
        Workflow::History->new({
            action      => $action,
            description => $description,
            user        => $user,
        })
    );
}

sub set_workflow_relation($self, $companies_fkey, $users_fkey, $workflow, $workflow_id, $key_value){
    Engine::Model::Workflowrelation->new(
        db => $self->db
    )->insert(
        $companies_fkey,
        0,
        $workflow,
        $workflow_id,
        $key_value
    );
}

sub capture_message($self, $err, $caller1, $caller2, $caller3) {
    Sentinel::Helpers::Sentinelsender->new()->capture_message (
        $self->pg, $caller1, $caller2, $caller3, $err
    );
    workflow_error $err;
}
1;