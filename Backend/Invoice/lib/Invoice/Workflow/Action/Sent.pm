package Invoice::Workflow::Action::Sent;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';
use feature 'say';

use Mailer::Helpers::Workflow;
use Invoice::Helpers::Mailsent;

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();
    my $context = $wf->context;

    my $result = Invoice::Helpers::Mailsent->new(
        pg => $pg
    )->set_as_sent(
        $context->param('mailer_mails_pkey)')
    );

    if($result ==1) {
        Mailer::Helpers::Workflow->new(db => $pg->db)->set_workflow_status($wf->id, 1);
    }
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'InvoicePersister' )->get_pg();
}
1;