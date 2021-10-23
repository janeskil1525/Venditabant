package venditabant::Helpers::Checkpoints::Check::SqlFalse;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::AutoTodo;
has 'db';

async sub check ($self, $companies_pkey, $check) {

    my $result = $self->db->query(
        $check->{check_condition},
            ($companies_pkey)
    )->hash;

    if(!$result->{result}) {
        venditabant::Model::AutoTodo->new(
            db => $self->db
        )->upsert(
            $companies_pkey, $check
        );
    }
    return $result->{result};
}
1;