package Engine::Load::DataPrecheck;
use Mojo::Base -base, -signatures, -async_await;

use venditabant::Helpers::Factory::Loader;
use Engine::Config::Configuration;

use Workflow::Exception qw( configuration_error );
use Log::Log4perl qw(:easy);

has 'pg';

async sub precheck ($self, $worlflow, $data) {

    my $class;
    my $fieldclass;
    my $required_classes = '';

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Load::DataPrecheck precheck Starting precheck"
    );

    my $config = await $self->_init_precheck($worlflow);
    my $actions = $config->{precheck}->{actions};
    my $error = 0;
    foreach my $action (@{$actions->{action}}) {
        $log->debug(
            "Engine::Load::DataPrecheck precheck will create $action->{class}"
        );
        if(exists $action->{field} and ref $action->{field} eq 'ARRAY') {
            foreach my $field (@{$action->{field}}) {
                $fieldclass = await $self->_require($required_classes, $field->{class});
                if(ref $fieldclass ne $field->{class}) {
                    $fieldclass = $field->{class}->new(pg => $self->pg);
                }
                $log->debug(
                    "Engine::Load::DataPrecheck precheck will check field $field->{name}"
                );

                my $method = $field->{method};
                $data = await $fieldclass->$method($field->{name}, $field->{required}, $data);
            }
        }

        if(!exists $data->{error}) {
            $class = await $self->_require($required_classes, $action->{class});
            if(ref $class ne $action->{class}) {
                $class = $action->{class}->new(pg => $self->pg);
            }

            $log->debug(
                "Engine::Load::DataPrecheck precheck will perform action $action->{name}"
            );

            my $method = $action->{method};
            $data = await $class->$method($data);
        }
    }

    return $data;
}

async sub _require($self, $required_classes, $class) {
    if(index($required_classes, $class) == -1) {
        eval "require $class" or die $@;
        $required_classes .= $class . ' ';
    }
}

async sub _init_precheck($self, $workflow) {

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Load::DataPrecheck _init_factory Starting to configure workflow factory"
    );

    my $types = "('precheck')";

    my $config = await Engine::Config::Configuration->new(
        pg => $self->pg
    )->load_config(
        $workflow, $types
    );

    return $config;
}
1;