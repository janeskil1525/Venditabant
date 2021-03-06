package Invoice::Workflow::Action::Print;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();
    my $context = $wf->context;

}

sub get_pg($self) {
    return  FACTORY->get_persister( 'InvoicePersister' )->get_pg();
}
1;