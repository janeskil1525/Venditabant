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
has 'log';

sub _init($self, $wf, $persister) {
    $self->pg($self->get_pg($persister));
    $self->context($wf->context);
    $self->db($self->pg->db);
    $self->tx($self->db->begin);
    $self->data($self->context->param('data'));
    $self->workflow($self->context->param('workflow'));
    $self->log($self->context->param('log'));
    my $temp=1;
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
    my $err;
    eval {
        Engine::Model::Workflowrelation->new(
            db => $self->db
        )->insert(
            $companies_fkey,
            $users_fkey,
            $workflow,
            $workflow_id,
            $key_value
        );
    };
    $err = $@ if $@;
    $self->capture_message($@, (caller(0))[1], (caller(0))[0], (caller(0))[3]) if $err;;
}

sub capture_message($self, $err, $caller1, $caller2, $caller3) {
    Sentinel::Helpers::Sentinelsender->new()->capture_message (
        $self->pg, $caller1, $caller2, $caller3, $err
    );
    $self->log->error($err);
    workflow_error $err;
}
1;