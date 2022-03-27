package Workflows::Helper::Workflows;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Workflows::Model::Workflows;
use Workflows::Model::WorkflowItems;

has 'pg';



async sub load_list($self, $companies_pkey, $users_pkey) {

    return Workflows::Model::Workflows->new(
        db => $self->pg->db
    )->load_list($companies_pkey, $users_pkey);
}

async sub upsert ($self, $companies_pkey, $users_pkey, $workflow ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $customers_pkey = Workflows::Model::WorkflowItems->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $workflow
        );
        $tx->commit();
    };
    $err = $@ if $@;
    # $self->capture_message (
    #     $self->pg, '',
    #     'venditabant::Helpers::Workflow::Workflows', 'upsert', $err
    # ) if $err;

    return $err ? $err : 'success';
}

async sub load_workflow($self, $companies_pkey, $users_pkey, $workflows_fkey, $workflow_type) {

    my $customers_pkey = Workflows::Model::WorkflowItems->new(
        db => $self->pg->db
    )->load_workflow(
        $companies_pkey, $users_pkey, $workflows_fkey, $workflow_type
    );

}

1;