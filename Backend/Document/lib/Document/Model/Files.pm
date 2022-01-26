package Document::Model::Files;
use Mojo::Base -base, -signatures;


has 'db';

sub insert($self, $data) {

    my $files_pkey = $self->db->insert(
        'files',
            {
                name      => $data->{name},
                path      => $data->{path},
                type      => $data->{type},
                full_path => $data->{full_path}
            },
            {
                returning => ['files_pkey']
            }

    )->hash->{files_pkey};

    return $files_pkey;
}
1;