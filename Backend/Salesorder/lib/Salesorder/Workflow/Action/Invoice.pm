package Engine::Workflow::Action::Salesorder::Invoice;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::Exception qw( workflow_error );

use Engine::Model::Counter;
use Salesorder::Model::Head;

sub execute ($self, $wf) {

    my $pg = $self->get_pg();

    my $context = $wf->context;
}

1;