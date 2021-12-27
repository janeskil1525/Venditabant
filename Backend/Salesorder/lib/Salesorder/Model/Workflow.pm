package Salesorder::Model::Workflow;
use Mojo::Base -base, -signatures, -async_await;

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

sub load_workflow_id($self, $salesorders_pkey) {

    my $result = $self->db->select(
        'workflow_salesorders',['workflow_id'],
            {
                salesorders_pkey => $salesorders_pkey,
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;

    return $hash->{workflow_id};
}
1;