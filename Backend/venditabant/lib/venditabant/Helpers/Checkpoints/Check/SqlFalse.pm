package venditabant::Helpers::Checkpoints::Check::SqlFalse;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::AutoTodo;
has 'db';

async sub check ($self, $companies_pkey, $check) {

    my $result;
    eval {
        $result = $self->db->query(
            $check->{check_condition},
            ($companies_pkey)
        )->hash;
    };
    say "check " . $@ if $@;


    return $result;
}
1;