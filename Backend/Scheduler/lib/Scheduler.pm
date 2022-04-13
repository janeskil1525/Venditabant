package Scheduler;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Scheduler::Model::Schedules;
use Scheduler::Helpers::Processor;

our $VERSION = '0.02';

has 'pg';

async sub check_all ($self) {

    my $err;
    eval {
        my $schedules = await Scheduler::Model::Schedules->new(
            db => $self->pg->db
        )->load_list_p();

        my $processor = Scheduler::Helpers::Processor->new(
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
        $self->pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;
}
1;