package venditabant::Helpers::System::Settings;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Jwt;
use venditabant::Model::System::Settings;

use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $users_pkey, $data) {
    my $err;
    eval {
        $data->{value} = await venditabant::Helpers::Jwt->new()->encode_jwt_p($data->{value});

        my $system_settings_pkey = await venditabant::Model::System::Settings->new(
            db => $self->pg->db
        )->upsert(
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Stockitems', 'upsert', $@
    ) if $err;

    return 'success' unless $err;
    return $err;
}

async sub load_system_setting($self, $companies_pkey, $users_pkey, $setting) {

    my $setting_obj = await venditabant::Model::System::Settings->new(
        db => $self->pg->db
    )->load_setting(
        $setting
    );

    if(exists $setting_obj->{value} and $setting_obj->{value} ne '') {
        $setting_obj->{value} = await venditabant::Helpers::Jwt->new()->decode_jwt_p(
            $setting_obj->{value}
        );
    }

    return $setting_obj;
}
1;