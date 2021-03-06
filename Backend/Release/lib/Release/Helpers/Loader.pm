package Release::Helpers::Loader;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures;

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