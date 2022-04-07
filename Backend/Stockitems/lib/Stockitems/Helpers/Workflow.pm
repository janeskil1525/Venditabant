package Stockitems::Helpers::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Stockitems::Model::Workflow;

has 'pg';

sub load_workflow_id($self, $stockitems_fkey) {

    my $workflow_id = Stockitems::Model::Workflow->new(
        db => $self->pg->db
    )->load_workflow_id($stockitems_fkey);

    return $workflow_id;
}

async sub load_workflow_id_p($self, $stockitems_fkey) {

    my $workflow_id = Stockitems::Model::Workflow->new(
        db => $self->pg->db
    )->load_workflow_id($stockitems_fkey);

    return $workflow_id;
}

sub insert($self, $workflow_id, $stockitems_fkey, $users_pkey, $companies_pkey) {
    return Stockitems::Model::Workflow->new(
        db => $self->pg->db
    )->insert(
        $workflow_id, $stockitems_fkey, $users_pkey, $companies_pkey
    );
}
1;