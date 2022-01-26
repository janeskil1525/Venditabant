package Document::Helpers::Files;
use Mojo::Base -base, -signatures;

use Document::Model::Files;

has 'pg';

sub insert ($self, $data) {

    my $files_pkey = Document::Model::Files->new(
        db => $self->pg->db
    )->insert(
        $data
    );

    return $files_pkey;
}
1;