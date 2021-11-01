package venditabant::Model::System::Settings;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub load_setting($self, $setting) {

    my $result = $self->db->select(
        'system_settings', ['*'],
            {
                setting => $setting
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;
    return $hash;
}

1;