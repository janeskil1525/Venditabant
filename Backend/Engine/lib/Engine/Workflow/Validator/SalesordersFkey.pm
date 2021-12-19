package Engine::Workflow::Validator::SalesordersFkey;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Validator );

use Workflow::Exception qw( configuration_error validation_error);

sub _init {
    my ($self, $params) = @_;


}

sub validate {
    my ($self, $wf, $date_string) = @_;

}
1;