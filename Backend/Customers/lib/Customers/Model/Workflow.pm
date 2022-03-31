package Customers::Model::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

sub insert($self, $workflow_id, $customers_fkey, $users_pkey, $companies_pkey) {

    $self->db->insert(
        'workflow_customer',
            {
                workflow_id     => $workflow_id,
                customers_fkey  => $customers_fkey,
                users_fkey      => $users_pkey,
                companies_fkey  => $companies_pkey
            }
    );
}

sub load_workflow_id($self, $customers_fkey) {

    my $result = $self->db->select(
        'workflow_customer',['workflow_id'],
            {
                customers_fkey  => $customers_fkey,
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;

    return $hash->{workflow_id};
}

sub load_workflow_list ($self) {

    my $result = $self->db->select(
        'workflow_customer',
            ['*'],
            {
                closed => 'false',
            }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows;

    return $hash;
}
1;