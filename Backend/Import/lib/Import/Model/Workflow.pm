package Import::Model::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

sub upsert($self, $workflow_id, $source_pkey, $target_pkey) {

    $self->db->insert(
        'workflow_import',
            {
                workflow_id => $workflow_id,
                source_pkey => $source_pkey,
                target_pkey => $target_pkey,
                import_type => $import_type,
            }
    );
}

sub load_workflow_id($self, $source_pkey) {

    my $result = $self->db->select(
        'workflow_import',
            ['workflow_id'],
            {
                source_pkey => $salesorders_pkey,
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;

    return $hash->{workflow_id};
}
1;