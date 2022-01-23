package Engine::Model::Workflows;
use Mojo::Base -base, -signatures, -async_await;

has 'db';

async sub load_list($self) {

    my $result = $self->db->select(
        'workflows',
        ['workflow']
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows() > 0;

    return $hash;
}

1;