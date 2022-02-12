package Invoice::Model::Status;
use Mojo::Base -base, -signatures;

use Data::Dumper;

has 'db';

sub insert ($self,  $invoice_pkey, $status) {

    $self->db->insert(
        'invoice_status',{
            invoice_fkey => $invoice_pkey,
            status       => $status
        }
    );
}

1;