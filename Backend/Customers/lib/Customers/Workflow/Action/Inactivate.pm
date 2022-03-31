package Customers::Workflow::Action::Inactivate;
use strict;
use warnings FATAL => 'all';
use base qw( Engine::Workflow::Action::Base );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );


sub execute ($self, $wf) {

    my $pg = $self->get_pg('CustomerPersister');
    my $context = $wf->context;



}

1;