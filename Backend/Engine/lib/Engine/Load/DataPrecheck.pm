package Engine::Load::DataPrecheck;
use Mojo::Base -base, -signatures;

use venditabant::Helpers::Factory::Loader;
use Engine::Config::Configuration;

use Workflow::Exception qw( configuration_error );

has 'pg';
has 'log';

sub precheck ($self, $worlflow, $data) {

    my $class;
    my $fieldclass;
    my $required_classes = '';

    $self->log->debug(
        "Engine::Load::DataPrecheck precheck Starting precheck"
    );

    my $config = $self->_init_precheck($worlflow);
    my $groups = $config->{precheck}->{actions}->{groups};
    my $error = 0;
    foreach my $group (@{$groups}) {
        if ($self->check_condition($group->{condition}, $data->{actions})) {
            my $actions = $group->{action};
            foreach my $action (@{$actions}) {
                $self->log->debug(
                    "Engine::Load::DataPrecheck precheck will create $action->{class}"
                );
                if (exists $action->{field} and ref $action->{field} eq 'ARRAY') {
                    foreach my $field (@{$action->{field}}) {
                        $fieldclass = $self->_require($required_classes, $field->{class});
                        if (ref $fieldclass ne $field->{class}) {
                            $fieldclass = $field->{class}->new(pg => $self->pg);
                        }
                        $self->log->debug(
                            "Engine::Load::DataPrecheck precheck will check field $field->{name}"
                        );

                        my $method = $field->{method};
                        $data = await $fieldclass->$method($field->{name}, $field->{required}, $data);
                    }
                }
                if (!exists $data->{error}) {
                    my $err;
                    eval {
                        $class = $self->_require($required_classes, $action->{class});
                        if (ref $class ne $action->{class}) {
                            $class = $action->{class}->new(pg => $self->pg);
                        }

                        $self->log->debug(
                            "Engine::Load::DataPrecheck precheck will perform action $action->{name}"
                        );

                        my $method = $action->{method};
                        $data = await $class->$method($data);
                    };
                    $err = $@ if $@;
                    $self->log->error(
                        "Engine::Load::DataPrecheck precheck  " . $err
                    ) if $err;
                }
            }
        }
    }
    return $data;
}

sub check_condition($self, $condition, $actions) {

    my $exists = 0;
    if(ref $actions eq 'ARRAY') {
        foreach my $action (@{$actions}) {
            if(index($condition, $action) > -1) {
                $exists = 1;
            }
        }
    } else {
        if(index($condition, $actions) > -1) {
            $exists = 1;
        }
    }

    return $exists;
}

sub _require($self, $required_classes, $class) {
    if(index($required_classes, $class) == -1) {
        eval "require $class" or die $@;
        $required_classes .= $class . ' ';
    }
}

sub _init_precheck($self, $workflow) {


    $self->log->debug(
        "Engine::Load::DataPrecheck _init_factory Starting to configure workflow factory"
    );

    my $types = "('precheck')";

    my $config = Engine::Config::Configuration->new(
        pg => $self->pg
    )->load_config(
        $workflow, $types
    );

    return $config;
}
1;