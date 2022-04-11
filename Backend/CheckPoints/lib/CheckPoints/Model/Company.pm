package CheckPoints::Model::Company;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

has 'db';

async sub load_list_p ($self) {

    my $result = $self->db->select(
        'companies', undef
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;
    return $hash
}

async sub load_p ($self, $companies_pkey, $users_pkey) {

    my $result = $self->db->select(
        'companies', undef,
        {
            companies_pkey => $companies_pkey
        }
    );
    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;
    return $hash
}

1;