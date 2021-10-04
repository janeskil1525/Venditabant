package venditabant::Helpers::Parameter::Parameters;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Parameters;
use venditabant::Model::ParameterItems;
use Data::Dumper;

has 'pg';

async sub load_parameter_list ($self, $companies_pkey, $parameter) {

    my $parameters_pkey = await venditabant::Model::Parameters->new(
        db => $self->pg->db
    )->load_parameter_pkey_p(
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
1;