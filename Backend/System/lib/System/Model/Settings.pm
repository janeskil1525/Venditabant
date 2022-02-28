package System::Model::Settings;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

sub load_setting($self, $setting) {

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

async sub load_setting_p($self, $setting) {

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

async sub upsert($self, $companies_pkey, $users_pkey, $data) {

    my $stmt = qq {
        INSERT INTO system_settings (insby, modby, setting, value)
            VALUES((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?)
        ON CONFLICT (setting)
        DO UPDATE SET moddatetime = now(),
                modby = (SELECT userid FROM users WHERE users_pkey = ?), value = ?
        RETURNING system_settings_pkey
    };

    my $system_settings_pkey = $self->db->query($stmt,(
        $users_pkey,
        $users_pkey,
        $data->{setting},
        $data->{value},
        $users_pkey,
        $data->{value},
    ))->hash->{system_settings_pkey};

    return $system_settings_pkey;
}
1;