package CheckPoints::Helpers::Check::SqlFalse;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

has 'db';

async sub check ($self, $companies_pkey, $check) {

    my $result = $self->db->query(
        $check->{check_condition},
        ($companies_pkey)
    )->hash;

    return $result;
}
1;