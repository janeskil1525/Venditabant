package venditabant::Helpers::Schedules::Processor;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Factory::Loader;

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
        await $worker->work();
    }
}
1;