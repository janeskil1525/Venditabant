package CheckPoints::Model::Checks;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

has 'db';

async sub load_list_p ($self) {

    my $result = $self->db->select(
        'checks', undef
    );

    my $hash;

    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}
1;