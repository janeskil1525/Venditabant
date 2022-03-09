package Mailer::Helpers::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Mailer::Model::Workflow;

has 'pg';

async sub load_workflow_list($self) {

    return Mailer::Model::Workflow->new(
        db => $self->pg->db
    )->load_workflow_list();

}

1;