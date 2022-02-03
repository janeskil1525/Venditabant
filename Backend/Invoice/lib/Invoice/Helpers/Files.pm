package Invoice::Helpers::Files;
use Mojo::Base -base, -signatures;

use Invoice::Model::Files;

has 'pg';

sub load_file($self, $invoice_pkey, $type) {

    my $file = Invoice::Model::Files->new(
        db => $self->pg->db
    )->load_file(
        $invoice_pkey, $type
    );

    return $file;
}

sub insert ($self, $data) {

    my $files_invoice_pkey = Invoice::Model::Files->new(
        db => $self->pg->db
    )->insert(
        $data
    );

    return $files_invoice_pkey;
}
1;