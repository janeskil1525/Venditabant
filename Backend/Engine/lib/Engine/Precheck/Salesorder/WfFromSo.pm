package Engine::Precheck::Salesorder::WfFromSo;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Log::Log4perl qw(:easy);

use Engine::Model::Salesorder::Workflow;

has 'pg';

async sub load_workflow_id ($self, $data) {

    $data->{workflow_id} = Engine::Model::Salesorder::Workflow->new(
        db => $self->pg->db
    )->load_workflow_id(
        $data->{salesorders_pkey}
    );

    return $data;
}

1;