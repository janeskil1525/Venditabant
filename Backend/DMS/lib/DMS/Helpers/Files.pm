package DMS::Helpers::Files;
use Mojo::Base -base, -signatures;

use DMS::Model::Files;

has 'pg';

sub insert ($self, $data) {

    my $files_pkey = DMS::Model::Files->new(
        db => $self->pg->db
    )->insert(
        $data
    );

    return $files_pkey;
}
1;