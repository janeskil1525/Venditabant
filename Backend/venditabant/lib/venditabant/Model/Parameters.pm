package venditabant::Model::Parameters;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

async sub load_parameter_p ($self, $companies_pkey, $parameter) {

    my $result = await $self->db->select_p('parameters',
        undef,
        {
            companies_fkey => $companies_pkey,
            parameter      => $parameter,
        }
    );

    my $hash;
    $hash = $result->hash if $result->rows;

    return $hash;
}

async sub load_parameter_pkey_p ($self, $companies_pkey, $parameter) {

    my $result = await $self->db->select_p('parameters',
        ['parameters_pkey'],
        {
            companies_fkey => $companies_pkey,
            parameter      => $parameter,
        }
    );

    my $parameters_pkey = 0;
    $parameters_pkey = $result->hash->{parameters_pkey} if $result->rows;

    return $parameters_pkey;
}
1;