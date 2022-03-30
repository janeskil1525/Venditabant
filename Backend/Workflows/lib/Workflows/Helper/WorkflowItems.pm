package Workflows::Helper::WorkflowItems;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Workflows::Model::WorkflowItems;

has 'pg';


async sub load_workflow($self, $companies_pkey, $users_pkey, $workflows_fkey, $workflow_type) {

    return Workflows::Model::WorkflowItems->new(
        db => $self->pg->db
    )->load_workflow(
        $companies_pkey, $users_pkey, $workflows_fkey, $workflow_type
    );
}

async sub upsert($self, $companies_pkey, $users_pkey, $workflow) {
    return Workflows::Model::WorkflowItems->new(
        db => $self->pg->db
    )->upsert(
        $companies_pkey, $users_pkey, $workflow
    );
}

1;