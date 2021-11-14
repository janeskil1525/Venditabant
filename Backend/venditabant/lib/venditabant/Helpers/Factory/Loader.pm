package venditabant::Helpers::Factory::Loader;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

sub load_class ($self, $class) { # $class ($class)

    chomp $class;
    if (length($class) > 0) {
        eval "require $class" or {
            $self->capture_message(
                $self->pg, '',
                'venditabant::Helpers::Factory::Loader', 'load_class', $@
            )
        }
    } else {
        $class = undef;
    }

    return $class->new(
        db => $self->db
    ) if $class;

}

1;