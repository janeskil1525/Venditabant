package Scheduler::Helpers::Loader;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

has 'db';

sub load_class ($self, $class) { # $class ($class)

    chomp $class;
    if (length($class) > 0) {
        eval "require $class" or die $@
    } else {
        $class = undef;
    }

    return $class->new(
        db => $self->db
    ) if $class;

}

1;