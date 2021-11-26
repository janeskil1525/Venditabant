package venditabant::Helpers::Parameter::Parameters;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Parameters;
use venditabant::Model::ParameterItems;
use Data::Dumper;

has 'pg';

async sub load_parameter_list ($self, $companies_pkey, $parameter) {

    my $parameters_pkey = await $self->get_parameter_pkey(
        $companies_pkey, $parameter
    );

    my $parameters;
    if($parameters_pkey > 0) {
        $parameters = await venditabant::Model::ParameterItems->new(
            db => $self->pg->db
        )->load_parameter_p(
            $parameters_pkey, $parameter
        );
    }

    return $parameters;
}

async sub upsert ($self, $companies_pkey, $users_pkey, $data) {
    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $parameters_pkey = await venditabant::Model::Parameters->new(
            db => $db
        )->upsert_p(
            $companies_pkey,
            $users_pkey,
            $data->{parameter}
        );

        await venditabant::Model::ParameterItems->new(
            db => $db
        )->upsert_p(
            $users_pkey,
            $parameters_pkey,
            $data->{param_value},
            $data->{param_description},
            $data->{parameters_items_pkey},
        );
        $tx->commit();
    };

    $err = $@ if $@;
    $self->capture_message (
        $self->pg,'venditabant' ,
        'venditabant::Helpers::Parameter::Parameters;', 'upsert', $err
    ) if $err;

    return $err ? $err : 'success';
}

async sub delete ($self, $companies_pkey, $users_pkey, $data) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        await venditabant::Model::ParameterItems->new(
            db => $db
        )->delete_p(
            $data->{parameters_items_pkey}
        );
        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg,'venditabant' ,
        'venditabant::Helpers::Parameter::Parameters;', 'delete', $err
    ) if $err;

    return $err ? $err : 'success';
}

async sub get_parameter_pkey ($self,$companies_pkey, $parameter) {

    my $parameters_pkey = venditabant::Model::Parameters->new(
        db => $self->pg->db
    )->load_parameter_pkey_p(
        $companies_pkey, $parameter
    );

    return $parameters_pkey;
}

async sub get_parameter_item_from_pkey ($self, $companies_pkey, $parameters_items_pkey) {

    my $parameter = venditabant::Model::ParameterItems->new(
        db => $self->pg->db
    )->load_parameter_from_pkey(
        $companies_pkey, $parameters_items_pkey
    );

    return $parameter;
}
1;