package venditabant::Model::Lan::Translations;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub load_translation ($self, $languages_fkey, $module, $tag) {

    my $result = $self->db->select(
        'translations',
            ['translation'],
            {
                languages_fkey => $languages_fkey,
                module         => $module,
                tag            => $tag,
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash
}
1;