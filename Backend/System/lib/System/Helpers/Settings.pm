package System::Helpers::Settings;
use Mojo::Base -base, -signatures, -async_await;

use System::Helpers::Jwt;
use System::Model::Settings;

use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $users_pkey, $data) {

    my $err;
    eval {
        $data->{value} = await System::Helpers::Jwt->new()->encode_jwt_p($data->{value});

        my $system_settings_pkey = await System::Model::Settings->new(
            db => $self->pg->db
        )->upsert(
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;

    return 'success' unless $err;
    return $err;
}

async sub load_system_setting_p($self, $companies_pkey, $users_pkey, $setting) {

    my $setting_obj = await System::Model::Settings->new(
        db => $self->pg->db
    )->load_setting_p(
        $setting
    );

    if(exists $setting_obj->{value} and $setting_obj->{value} ne '') {
        $setting_obj->{value} = await System::Helpers::Jwt->new()->decode_jwt_p(
            $setting_obj->{value}
        );
    }

    return $setting_obj;
}

sub load_system_setting($self, $companies_pkey, $users_pkey, $setting) {

    my $setting_obj = System::Model::Settings->new(
        db => $self->pg->db
    )->load_setting(
        $setting
    );

    if(exists $setting_obj->{value} and $setting_obj->{value} ne '') {
        $setting_obj->{value} = System::Helpers::Jwt->new()->decode_jwt(
            $setting_obj->{value}
        );
    }

    return $setting_obj;
}
1;