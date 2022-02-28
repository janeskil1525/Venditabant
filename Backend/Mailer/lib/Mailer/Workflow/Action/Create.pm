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

use Mailer::Helpers::Processor;
use Mailer::Model::MailerMails;
use Mailer::Model::Workflow;

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();
    my $context = $wf->context;
    my $used_recipients = '';

    $wf->add_history(
        Workflow::History->new({
            action      => "New mail process started",
            description => "To be sent to recipients connected to $comntext->params('customer')->{name} ",
            user        => 'System',
        })
    );

    my $mail = Mailer::Helpers::Processor->new(
        pg => $pg
    )->create(
        $comntext->params('company'),
        $comntext->params('customer'),
        $comntext->params('mappings'),
        $comntext->params('template')
    );

    my $recipients = $context->params('recipients');
    my $mailer_mails_fkeys = '';
    foreach my $recipient (@{$recipients}) {
        if(index($used_recipients, $recipient) == -1) {
            $used_recipients .= $recipient;

            my $mailer_mails_pkey = Mailer::Model::MailerMails->new(
                db => $pg->db
            )->insert(
                $comntext->params('company')->{companies_pkey},
                $recipient,
                $mail->{subject},
                $mail->{mail_content},
            );

            if(defined $mailer_mails_fkeys) {
                $mailer_mails_fkeys .= ',' . $mailer_mails_pkey;
            } else {
                $mailer_mails_fkeys = $mailer_mails_pkey;
            }
        }
    }

    Mailer::Model::Workflow->new(
        db => $pg->db
    )->insert(
        $wf->id, $mailer_mails_fkeys
    );

    return 1;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'MailPersister' )->get_pg();
}
1;