package Invoice::Workflow::Action::Sent;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';
use feature 'say';

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();
    my $context = $wf->context;


}

sub get_pg($self) {
    return  FACTORY->get_persister( 'InvoicePersister' )->get_pg();
}
1;