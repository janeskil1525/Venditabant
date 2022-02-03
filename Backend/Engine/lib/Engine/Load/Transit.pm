package Engine::Load::Transit;
use Mojo::Base -base, -signatures, -async_await;

use Engine::Model::Workflows;
use Engine::Config::Configuration;

has 'pg';

async sub auto_transit ($self) {

    my $class;
    my $required_classes = '';
    my $data;
    my $result;

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Load::Transit auto_transit Starting precheck"
    );

    my $workflows = await Engine::Model::Workflows->new(
        db => $self->pg->db
    )->load_list();

    foreach my $workflow (@{$workflows}) {
        my $transits = await $self->_auto_transit($workflow->{workflow});

        my $error = 0;
        my $err;

        foreach my $transit (@{$transits}) {
            if(exists $transit->{transit}) {
                $transit = $transit->{transit};
            }

            $log->debug(
                "Engine::Load::Transit auto_transit will create $transit->{class}"
            );

            eval {
                $class = await $self->_require($required_classes, $transit->{class});
                if (ref $class ne $transit->{class}) {
                    $class = $transit->{class}->new(pg => $self->pg);
                }

                $log->debug(
                    "Engine::Load::Transit auto_transit will perform action $transit->{name}"
                );

                my @activities = split(",", $transit->{activity});

                my $method = $transit->{method};
                $data->{data} = await $class->$method();
                foreach my $activity (@activities) {
                    push @{$data->{activity}}, $activity;
                }
                $data->{workflow} = $workflow;
                push @{$result}, $data;
            };
            $err = $@ if $@;
            $log->error(
                "Engine::Load::Transit auto_transit  " . $err
            ) if defined $err;
        }
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

    my $result;
    if(exists $config->{auto_transit}) {
        if(ref $config->{auto_transit}->{transits} eq 'ARRAY') {
            $result = $config->{auto_transit}->{transits}[0]->{transit};
        } else {
            $result = $config->{auto_transit}->{transits};
        }

    }
    return $result;
}

1;