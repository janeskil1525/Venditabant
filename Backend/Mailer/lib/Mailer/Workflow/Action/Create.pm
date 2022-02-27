package Mailer::Workflow::Action::Create;
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
    my $used_recipients = '';

    $context = $context;
    my $recipients = $context->params('recipients');
    foreach my $recipient (@{$recipients}) {
        if(index($used_recipients, $recipient) == -1) {
            $used_recipients .= $recipient;


        }
    }



}

sub get_pg($self) {
    return  FACTORY->get_persister( 'MailPersister' )->get_pg();
}
1;