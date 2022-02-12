package Invoice::Helpers::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Invoice::Model::Workflow;

has 'pg';

async sub load_workflow_list($self) {

    return Invoice::Model::Workflow->new(
        db => $self->pg->db
    )->load_workflow_list();

}

1;