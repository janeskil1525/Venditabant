package venditabant::Model::Lan::Languages;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';


async sub load_list_p ($self) {

    my $result = $self->db->select(
        'languages', undef
    );

    my $hash;

    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}

1;