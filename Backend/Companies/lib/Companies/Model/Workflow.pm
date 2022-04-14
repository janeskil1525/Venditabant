package Companies::Model::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

sub insert($self, $workflow_id, $users_pkey, $companies_pkey) {

    $self->db->insert(
        'workflow_companies',
            {
                workflow_id     => $workflow_id,
                users_fkey      => $users_pkey,
                companies_fkey  => $companies_pkey
            }
    );
}

sub load_workflow_id($self, $companies_fkey) {

    my $result = $self->db->select(
        'workflow_companies',['workflow_id'],
            {
                companies_fkey  => $companies_fkey,
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;

    return $hash->{workflow_id};
}

sub load_workflow_list ($self) {

    my $result = $self->db->select(
        'workflow_companies',
            ['*']
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows;

    return $hash;
}
1;