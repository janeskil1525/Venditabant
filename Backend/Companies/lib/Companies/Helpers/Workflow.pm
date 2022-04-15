package Companies::Helpers::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Companies::Model::Workflow;

has 'pg';

sub load_workflow_id($self, $customers_fkey) {

    my $workflow_id = Companies::Model::Workflow->new(
        db => $self->pg->db
    )->load_workflow_id($customers_fkey);

    return $workflow_id;
}

async sub load_workflow_id_p($self, $customers_fkey) {

    my $workflow_id = Companies::Model::Workflow->new(
        db => $self->pg->db
    )->load_workflow_id($customers_fkey);

    return $workflow_id;
}
1;