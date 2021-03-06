package venditabant::Model::System::Mappings;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

has 'db';

async sub load_mapping($self, $map) {
    my $result = $self->db->select(
        ['system_mappings',
            ['system_mappings_map', 'system_mappings_fkey' => 'system_mappings_pkey']],
        ['map_key', 'map_field', 'map_table'],
        {
            mapping => $map,
        }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}
1;