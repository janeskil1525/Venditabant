package venditabant::Helpers::Mailer::Mails::Invoice::Create;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Invoice::Invoices;
use venditabant::Helpers::Mailer::Mails::Loader::Templates;
use venditabant::Helpers::Mailer::Mails::Invoice::Text;
use venditabant::Helpers::System::Pdf;
use venditabant::Helpers::Mailer::System::Processor;
use venditabant::Model::Mail::MailerMailsAttachments;
use venditabant::Model::Mail::MailerMails;
use venditabant::Model::Lan::Translations;
use venditabant::Model::Users;
# use venditabant::Helpers::Mailer::System::Sender;


use Data::UUID;
use Data::Dumper;

has 'pg';

async sub create($self, $companies_pkey, $users_pkey, $invoice_pkey) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $invoice = await venditabant::Helpers::Invoice::Invoices->new(
            pg => $self->pg
        )->load_invoice_full(
            $companies_pkey, $users_pkey, $invoice_pkey
        );

        my $ug = Data::UUID->new();
        my $token = $ug->create();
        $invoice->{id_token} = $ug->to_string($token);

        my $template = await venditabant::Helpers::Mailer::Mails::Loader::Templates->new(
            pg => $self->pg
        )->load_template(
            $companies_pkey, $users_pkey, $invoice->{customer}->{languages_fkey}, 'Invoice'
        );

        my $mail_content = await venditabant::Helpers::Mailer::Mails::Invoice::Text->new(
            pg => $self->pg
        )->map_text(
            $companies_pkey, $users_pkey, $invoice, $template
        );

        my $path = await venditabant::Helpers::System::Pdf->new(
            pg => $self->pg
        )->create(
            $companies_pkey, $users_pkey, $mail_content
        );

        my $recipients = await $self->get_recipients($companies_pkey, $users_pkey, $invoice);
        my $subject = await $self->get_subject($companies_pkey, $invoice);

        my $mailer_mails_pkey = await venditabant::Model::Mail::MailerMails->new(
            db => $db
        )->insert(
            $companies_pkey, $recipients, $subject, $mail_content
        );

        await venditabant::Model::Mail::MailerMailsAttachments->new(
            db => $db
        )->insert(
            $mailer_mails_pkey, $path
        );

        $tx->commit();

        await venditabant::Helpers::Mailer::System::Processor->new(
            pg => $self->pg
        )->process(
            $mailer_mails_pkey
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Mailer::Mails::Invoice::Create', 'create', $err
    ) if $err;


}

async sub get_subject($self, $companies_pkey, $invoice) {

    my $err;
    my $subject;
    eval {
        my $text = venditabant::Model::Lan::Translations->new(
            db => $self->pg->db
        )->load_translation(
            $invoice->{customer}->{languages_fkey}, "INVOICE_MAIL", "SUBJECT"
        );
        $subject = $invoice->{company}->{name} . $text . " " . $invoice->{invoice}->{invoiceno};
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Mailer::Mails::Invoice::Create', 'get_subject', $err
    ) if $err;

    return $subject;
}

async sub get_recipients($self, $companies_pkey, $users_pkey, $invoice) {

    my $err;
    my $recipients;
    eval {
        my $user = venditabant::Model::Users->new(
            db => $self->pg->db
        )->load_user_from_pkey(
            $users_pkey
        );

        $recipients = $invoice->{invoice}->{mailaddresses};
        $recipients .= ",$user->{username}";
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Mailer::Mails::Invoice::Create', 'get_recipients', $err
    ) if $err;

    return $recipients;
}

1;