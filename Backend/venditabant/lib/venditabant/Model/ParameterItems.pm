package venditabant::Model::ParameterItems;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

async sub load_parameter_p ($self, $parameters_fkey, $parameter) {

    my $result = await $self->db->select_p('parameters_items',
        undef,
        {
            parameters_fkey => $parameters_fkey,
        }
    );

    my $hash;
    $hash = $result->hashes if $result->rows;

    return $hash;
}

1;