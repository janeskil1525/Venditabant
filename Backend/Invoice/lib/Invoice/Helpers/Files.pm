package Invoice::Helpers::Files;
use Mojo::Base -base, -signatures;

use Invoice::Model::Files;

has 'pg';

sub insert ($self, $data) {

    my $files_invoice_pkey = Invoice::Model::Files->new(
        db => $self->pg->db
    )->insert(
        $data
    );

    return $files_invoice_pkey;
}
1;