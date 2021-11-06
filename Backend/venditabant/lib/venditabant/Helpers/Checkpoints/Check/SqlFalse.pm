package venditabant::Helpers::Checkpoints::Check::SqlFalse;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

async sub check ($self, $companies_pkey, $check) {

    my $result = $self->db->query(
        $check->{check_condition},
        ($companies_pkey)
    )->hash;

    return $result;
}
1;