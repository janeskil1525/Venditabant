package venditabant::Model::Scheduler::Schedules;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

async sub load_list_p($self) {

    my $stmt = qq {
        SELECT schedule FROM schedules ORDER BY schedule
    };

    my $result = $self->db->query(
        $stmt
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}
1;