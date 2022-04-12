package Scheduler::Helpers::Processor;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Scheduler::Helpers::Loader;
use Scheduler::Model::Schedules;
use Data::Dumper;

has 'pg';

async sub process($self, $schedule) {

    my $class = "Scheduler::Helpers::Schedules::" . $schedule->{schedule};

    my $worker = Scheduler::Helpers::Loader->new(
        db => $self->pg->db
    )->load_class(
        $class
    );

    if($worker) {
        my $result = await $worker->work();
        if($result->{result} ne 'success') {
            $self->capture_message (
                $self->pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], "Dumper($result)"
            );
        } else {
            my $schedules = await Scheduler::Model::Schedules->new(
                db => $self->pg->db
            )->next_run(
                $schedule, $result->{nextrun}
            );
        }
    }
}
1;