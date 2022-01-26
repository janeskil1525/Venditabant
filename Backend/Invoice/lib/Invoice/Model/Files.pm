package Invoice::Model::Files;
use Mojo::Base -base, -signatures;


has 'db';

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