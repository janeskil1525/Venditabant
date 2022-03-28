package Workflows;
use Mojo::Base -base, -signatures, -async_await;

our $VERSION = '0.2';


use Data::Dumper;
use Workflows::Helper::Workflows;
use Workflows::Helper::Export;

has 'pg';

async sub export($self) {

    return Workflows::Helper::Export->new(
        pg => $self->pg
    )->export();
}

async sub load_list($self, $companies_pkey, $users_pkey) {

    return Workflows::Model::Workflows->new(
        db => $self->pg->db
    )->load_list($companies_pkey, $users_pkey);
}

async sub upsert ($self, $companies_pkey, $users_pkey, $workflow ) {

    my $result = Workflows::Helper::WorkflowItems->new(
        pg => $self->pg
    )->upsert(
        $companies_pkey, $users_pkey, $workflow
    );

    return $result;
}

async sub load_workflow($self, $companies_pkey, $users_pkey, $workflows_fkey, $workflow_type) {

    my $customers_pkey = Workflows::Helper::WorkflowItems->new(
        db => $self->pg->db
    )->load_workflow(
        $companies_pkey, $users_pkey, $workflows_fkey, $workflow_type
    );

}
1;