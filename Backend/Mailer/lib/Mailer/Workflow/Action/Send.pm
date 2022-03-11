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

use Mailer::Helpers::Sender;
use Mailer::Model::Workflow;
use Mailer::Model::MailerMails;
use System::Helpers::Settings;

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
        @mailer_mails_fkeys = split(',', $workflow->{mailer_mails_fkeys});
    } else {
        push (@mailer_mails_fkeys, $workflow->{mailer_mails_fkeys});
    }

    my $smtp = System::Helpers::Settings->new(
        pg => $pg
    )->load_system_setting(
        0,0,'SMTP'
    );

    my $mailer = Mailer::Helpers::Sender->new(
        pg            => $pg,
        server_adress => $smtp->{value}->{server_adress},
        smtp          => $smtp->{value}->{smtp},
        account       => $smtp->{value}->{sasl_username},
        passwd        => $smtp->{value}->{sasl_password},
    );

    my $mailermails = Mailer::Model::MailerMails->new(db => $pg->db);

    foreach my $mailer_mails_fkey (@mailer_mails_fkeys) {
        my $mail_result = $mailer->process(
            $mailer_mails_fkey
        );

        $mailermails->set_sent($mailer_mails_fkey);
    }

    return 1;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'MailPersister' )->get_pg();
}
1;