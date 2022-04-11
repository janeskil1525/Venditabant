package CheckPoints::Helpers::Check::SqlList;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

has 'db';

async sub check ($self, $companies_pkey, $check) {

    my $result = $self->db->query(
        $check->{check_condition},(
            $companies_pkey
        )
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}

1;