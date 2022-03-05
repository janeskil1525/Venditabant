package Mailer::Workflow::Action::Send;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );

use Mailer::Model::Workflow;

sub execute ($self, $wf) {

    my $pg = $self->get_pg();
    my $context = $wf->context;

    my $workflow = Mailer::Model::Workflow->new(
        db => $pg->db
    )->load_workflow(
        $wf->id
    );

    my @mailer_mails_fkeys;
    if(index($workflow->{mailer_mails_fkeys}, ',') > -1) {
        @mailer_mails_fkeys = split(',' $workflow->{mailer_mails_fkeys});
    } else {
        push (@mailer_mails_fkeys, $workflow->{mailer_mails_fkeys});
    }

    foreach my $mailer_mails_fkey (@mailer_mails_fkeys) {

    }
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'MailPersister' )->get_pg();
}
1;