package venditabant::Model::Company;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'pg';
has 'db';

sub insert ($self, $data) {

}

async sub load_list ($self) {

    my $result = $self->db->select(
        'companies', undef
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}
1;