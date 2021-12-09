package venditabant::Helpers::Workflow::Workflows;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;
use venditabant::Model::Workflow::Workflows;
use venditabant::Model::Workflow::WorkflowItems;

has 'pg';


async sub load_list($self, $companies_pkey, $users_pkey) {

    return venditabant::Model::Workflow::Workflows->new(
        db => $self->pg->db
    )->load_list($companies_pkey, $users_pkey);
}

async sub upsert ($self, $companies_pkey, $users_pkey, $workflow ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $customers_pkey = venditabant::Model::Workflow::WorkflowItems->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $workflow
        );
        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Workflow::Workflows', 'upsert', $err
    ) if $err;

    return $err ? $err : 'success';
}

async sub load_workflow($self, $companies_pkey, $users_pkey, $workflows_fkey, $workflow_type) {

    my $customers_pkey = venditabant::Model::Workflow::WorkflowItems->new(
        db => $self->pg->db
    )->load_workflow(
        $companies_pkey, $users_pkey, $workflows_fkey, $workflow_type
    );

}
1;