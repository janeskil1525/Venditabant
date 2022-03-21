package Mailer::Helpers::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Mailer::Model::Workflow;

has 'pg';

async sub load_workflow_list($self) {

    return Mailer::Model::Workflow->new(
        db => $self->pg->db
    )->load_workflow_list();

}

sub set_workflow_status ($self, $id, $status) {

    my $result = Mailer::Model::Workflow->new(
        db => $self->pg->db
    )->set_workflow_status (
        $id, $status
    );

    return $result;
}
1;