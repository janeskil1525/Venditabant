package venditabant::Model::Scheduler::Schedules;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

has 'db';

async sub load_list_p($self) {

    my $stmt = qq {
        SELECT schedules_pkey, schedule FROM schedules ORDER BY schedule
    };

    my $result = $self->db->query(
        $stmt
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}

async sub next_run ($self, $schedule, $next_run) {

    $self->db->update(
        'schedules',
            {
                nextexecution => $next_run,
                lastexecution => 'now()',
                moddatetime   => 'now()'
            },
            {
                schedules_pkey => $schedule->{ schedules_pkey }
            }
    );
}
1;