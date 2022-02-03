package Mailer::Helpers::Mailer::Mails::Invoice::Create;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Invoice::Invoices;
use venditabant::Helpers::Mailer::Mails::Loader::Templates;
use venditabant::Helpers::Mailer::Mails::Invoice::Text;
use venditabant::Helpers::System::Pdf;
use venditabant::Helpers::Mailer::System::Processor;
use Model::MailerMailsAttachments;
use venditabant::Model::Mail::MailerMails;
use venditabant::Model::Lan::Translations;
use venditabant::Helpers::Mailer::Mails::Utils::Subject;
use venditabant::Helpers::Mailer::Mails::Utils::Recipients;
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

        # my $path = await venditabant::Helpers::System::Pdf->new(
        #     pg => $self->pg
        # )->create(
        #     $companies_pkey, $users_pkey, $mail_content
        # );

        my $subject = await venditabant::Helpers::Mailer::Mails::Utils::Subject->new(
            pg             => $self->pg,
            companyname    => $invoice->{company}->{name},
            idno           => $invoice->{invoice}->{invoiceno},
            languages_fkey => $invoice->{customer}->{languages_fkey},
            module         => 'INVOICE_MAIL',
            tag            => 'SUBJECT',
        )->get_subject();

        my $recipients = await venditabant::Helpers::Mailer::Mails::Utils::Recipients->new(
            pg              => $self->pg,
            mailaddresses   => $invoice->{invoice}->{mailaddresses},
            users_pkey      => $users_pkey,
            companies_pkey  => $companies_pkey
        )->get_recipients();

        my $mailer_mails_pkey = await Model::MailerMails->new(
            db => $db
        )->insert(
            $companies_pkey, $recipients, $subject, $mail_content
        );

        # await Model::MailerMailsAttachments->new(
        #     db => $db
        # )->insert(
        #     $mailer_mails_pkey, $path
        # );

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

1;