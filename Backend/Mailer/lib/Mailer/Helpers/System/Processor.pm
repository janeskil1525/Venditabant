package Mailer::Helpers::Mailer::System::Processor;
use Mojo::Base 'venditabant::Helpers::Mailer::System::Sender', -signatures, -async_await;

use venditabant::Model::Mail::MailerMails;
use venditabant::Model::System::Settings;

has 'pg';

async sub process($self, $mailer_mails_pkey) {

    my $mail = await $self->_load_mail($mailer_mails_pkey);
    my $settings = await $self->_load_smtp_settings();
    my $mailed = await $self->_send($settings->{value}, $mail);

    if($mailed eq '1') {
        await $self->_set_mail_sent($mailer_mails_pkey)
    }

    return 1;
}

async sub _set_mail_sent($self, $mailer_mails_pkey) {

    my $err;
    eval {
        Model::MailerMails->new(
            db => $self->pg->db
        )->set_sent(
            $mailer_mails_pkey
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Stockitems', 'upsert', $@
    ) if $err;

    return '1' unless $err;
    return $err;
}

async sub _load_smtp_settings($self) {

    my $setting = await venditabant::Helpers::System::Settings->new(
        pg => $self->pg
    )->load_system_setting(
        0,0,'SMTP'
    );

    return $setting;
}

async sub _load_mail ($self, $mailer_mails_pkey) {
    return await Model::MailerMails->new(
        db => $self->pg->db
    )->load_mail(
        $mailer_mails_pkey
    );
}
1;