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

use Mailer::Model::MailerMailsAttachments;
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
            description => "To be sent to recipients connected to $context->param('customer')->{name} ",
            user        => 'System',
        })
    );

    my $company = $context->param('company');
    my $customer = $context->param('customer');
    my $mappings = $context->param('mappings');
    my $template = $context->param('template');
    my $mail = Mailer::Helpers::Processor->new(
        pg => $pg
    )->create(
        $company,
        $customer,
        $mappings,
        $template
    );

    my $recipients = $context->param('customer')->{recipients};
    my $mailer_mails_fkeys = '';
    foreach my $recipient (@{$recipients}) {
        $recipient =~ s/^\s+|\s+$//g;
        if(index($used_recipients, $recipient) == -1) {
            $used_recipients .= $recipient;
            my $mailer_mails_pkey = Mailer::Model::MailerMails->new(
                db => $pg->db
            )->insert(
                $context->param('company')->{companies_pkey},
                $recipient,
                $mail->{subject},
                $mail->{mail_content},
            );

            Mailer::Model::MailerMailsAttachments->new(
                db => $pg->db
            )->insert(
                $mailer_mails_pkey, $context->param('full_path')
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