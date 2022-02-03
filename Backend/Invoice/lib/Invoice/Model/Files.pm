package Invoice::Model::Files;
use Mojo::Base -base, -signatures;


has 'db';

sub load_file ($self, $invoice_fkey, $type) {

    my $result = $self->db->select(
        ['files', ['files_invoice', files_fkey => 'files_pkey']],
            ['*'],
        {
            invoice_fkey => $invoice_fkey,
            type         => $type,
        }
    );

    my $hash;
    $hash = $result->hash if defined $result and $result->rows() > 0;

    return $hash
}

sub insert ($self, $data) {

    my $files_invoice_pkey = $self->db->insert(
        'files_invoice',
            {
                files_fkey   => $data->{files_fkey},
                invoice_fkey => $data->{invoice_fkey},
            },
            {
                returning => ['files_invoice_pkey']
            }
    )->hash->{files_invoice_pkey};

    return $files_invoice_pkey
}
1;