package Invoice::Model::Workflow;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

sub insert($self, $workflow_id, $invoice_pkey, $users_pkey, $companies_pkey) {

    $self->db->insert(
        'workflow_invoice',
            {
                workflow_id    => $workflow_id,
                invoice_fkey   => $invoice_pkey,
                users_fkey     => $users_pkey,
                companies_fkey => $companies_pkey
            }
    );
}

sub load_workflow_id($self, $invoice_pkey) {

    my $result = $self->db->select(
        'workflow_invoice',['workflow_id'],
            {
                invoice_fkey => $invoice_pkey,
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;

    return $hash->{workflow_id};
}

sub load_workflow_list ($self) {

    my $result = $self->db->select(
        'workflow_invoice',
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