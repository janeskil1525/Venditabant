package Engine::Helpers::Parameter::Parameters;
use Mojo::Base -base, -signatures, -async_await;

use venditabant::Model::Parameters;
use venditabant::Model::ParameterItems;
use Data::Dumper;

has 'pg';

async sub get_parameter_item_from_pkey ($self, $companies_pkey, $parameters_items_pkey) {

    my $parameter = venditabant::Model::ParameterItems->new(
        db => $self->pg->db
    )->load_parameter_from_pkey(
        $companies_pkey, $parameters_items_pkey
    );

    return $parameter;
}
1;