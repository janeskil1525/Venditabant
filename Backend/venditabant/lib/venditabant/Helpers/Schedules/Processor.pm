package venditabant::Helpers::Schedules::Processor;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Factory::Loader;
use venditabant::Model::Scheduler::Schedules;
use Data::Dumper;

has 'pg';

async sub process($self, $schedule) {

    my $class = "venditabant::Helpers::Schedules::" . $schedule->{schedule};

    my $worker = venditabant::Helpers::Factory::Loader->new(
        db => $self->pg->db
    )->load_class(
        $class
    );

    if($worker) {
        my $result = await $worker->work();
        if($result->{result} ne 'success') {
            $self->capture_message (
                $self->pg, '',
                'venditabant::Helpers::Schedules::Processor', 'process', $class . ' \n' . $result
            );
        } else {
            my $schedules = await venditabant::Model::Scheduler::Schedules->new(
                db => $self->pg->db
            )->next_run(
                $schedule, $result->{nextrun}
            );
        }
    }
}
1;