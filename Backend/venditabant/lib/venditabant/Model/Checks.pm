package venditabant::Model::Checks;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;


async sub load_list_p ($self) {

    my $result = $self->db->select(
        'checks', undef
    );

    my $hash;

    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}
1;