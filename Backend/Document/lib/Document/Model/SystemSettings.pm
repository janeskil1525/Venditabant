package Document::Model::SystemSettings;
use Mojo::Base -base, -signatures;

use Data::Dumper;

has 'db';

sub load_setting($self, $setting) {

    my $result = $self->db->select(
        'system_settings',
            ['value'],
            {
                setting => $setting
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows();

    return $hash;
}

1;