package Engine::Load::Transit;
use Mojo::Base -base, -signatures, -async_await;

has 'pg';


async sub auto_transit ($self, $worlflow) {

    my $class;
    my $required_classes = '';
    my $data;
    my $result;

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Load::Transit auto_transit Starting precheck"
    );

    my $config = await $self->_auto_transit($worlflow);
    my $transits = $config->{auto_transit}->{actions};
    my $error = 0;
    my $err;
    
    foreach my $transit (@{$transits}) {
        $log->debug(
            "Engine::Load::Transit auto_transit will create $transit->{class}"
        );

        my $err;
        eval {
            $class = await $self->_require($required_classes, $transit->{class});
            if (ref $class ne $transit->{class}) {
                $class = $transit->{class}->new(pg => $self->pg);
            }

            $log->debug(
                "Engine::Load::Transit auto_transit will perform action $transit->{name}"
            );

            my $method = $transit->{method};
            $data->{data} = await $class->$method();
            $data->{action} = $transit->{action};
            push @{$result}, $data;
        };
        $err = $@ if $@;
        $log->error(
            "Engine::Load::Transit auto_transit  " . $err
        ) if $err;

    }

    return $result;
}

sub check_condition($self, $condition, $actions) {

    my $exists = 0;
    foreach my $action (@{$actions}) {
        if(index($condition, $action) > -1) {
            $exists = 1;
        }
    }
    return $exists;
}

async sub _require($self, $required_classes, $class) {
    if(index($required_classes, $class) == -1) {
        eval "require $class" or die $@;
        $required_classes .= $class . ' ';
    }
}

async sub _auto_transit($self, $workflow) {

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Load::Transit _init_factory Starting to configure workflow factory"
    );

    my $types = "('auto_transit')";

    my $config = await Engine::Config::Configuration->new(
        pg => $self->pg
    )->load_config(
        $workflow, $types
    );

    return $config;
}

1;