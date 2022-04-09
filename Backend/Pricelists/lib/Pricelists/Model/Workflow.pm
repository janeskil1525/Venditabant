package Pricelists::Model::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

sub insert($self, $workflow_id, $pricelists_fkey, $users_pkey, $companies_pkey) {

    $self->db->insert(
        'workflow_pricelist',
            {
                workflow_id     => $workflow_id,
                pricelists_fkey  => $pricelists_fkey,
                users_fkey      => $users_pkey,
                companies_fkey  => $companies_pkey
            }
    );
}

sub load_workflow_id($self, $pricelists_fkey) {

    my $result = $self->db->select(
        'workflow_pricelist',['workflow_id'],
            {
                pricelists_fkey  => $pricelists_fkey,
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;

    return $hash->{workflow_id};
}

1;