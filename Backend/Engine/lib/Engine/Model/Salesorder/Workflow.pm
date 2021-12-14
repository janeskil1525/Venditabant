package Engine::Model::Salesorder::Workflow;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

sub upsert($self, $workflow_id, $salesorders_pkey) {

    $self->db->insert(
        'workflow_salesorders',
            {
                workflow_id      => $workflow_id,
                salesorders_pkey => $salesorders_pkey,
            }
    );
}
1;