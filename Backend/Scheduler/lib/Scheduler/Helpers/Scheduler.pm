package venditabant::Helpers::Scheduler;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Scheduler::Schedules;
use venditabant::Helpers::Schedules::Processor;

has 'pg';

async sub check_all ($self) {

    my $err;
    eval {
        my $schedules = await venditabant::Model::Scheduler::Schedules->new(
            db => $self->pg->db
        )->load_list_p();

        my $processor = venditabant::Helpers::Schedules::Processor->new(
            pg => $self->pg
        );
        foreach my $schedule (@{$schedules}) {
            my $next_run = await $processor->process(
                $schedule
            );
        }
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Scheduler;', 'check_all', $err
    ) if $err;
}
1;