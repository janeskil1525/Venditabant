package Users::Model::Workflow;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

has 'db';

sub insert($self, $workflow_id,  $users_pkey) {

    $self->db->insert(
        'workflow_users',
        {
            workflow_id     => $workflow_id,
            users_fkey  => $users_pkey
        }
    );
}

sub load_workflow_id($self, $users_fkey) {

    my $result = $self->db->select(
        'workflow_users',['workflow_id'],
        {
            users_fkey  => $users_fkey,
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;

    return $hash->{workflow_id};
}

sub load_workflow_list ($self) {

    my $result = $self->db->select(
        'workflow_users',
        ['*']
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows;

    return $hash;
}
1;