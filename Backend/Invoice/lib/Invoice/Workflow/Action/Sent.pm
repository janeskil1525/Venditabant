package Invoice::Workflow::Action::Sent;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use Workflow::Factory qw(FACTORY);

use feature 'signatures';
use feature 'say';

use Mailer::Helpers::Workflow;
use Invoice::Helpers::Mailsent;

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();
    my $context = $wf->context;
    my @mailer_mails_fkey;
    if(index($context->param('mailer_mails_fkeys'),',') > -1) {
        @mailer_mails_fkey = split(',', $context->param('mailer_mails_fkeys'));
    } else {
         push @mailer_mails_fkey, $context->param('mailer_mails_fkeys');
    }

    my $result = Invoice::Helpers::Mailsent->new(
        pg => $pg
    )->set_as_sent(
        $mailer_mails_fkey[0]
    );

    if($result == 1) {
        Mailer::Helpers::Workflow->new(
            pg => $pg
        )->set_workflow_status(
            $wf->id, 1
        );
    }

    return $result;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'InvoicePersister' )->get_pg();
}
1;