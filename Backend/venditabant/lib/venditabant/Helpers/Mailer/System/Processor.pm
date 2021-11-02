package venditabant::Helpers::Mailer::System::Processor;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Mail::MailerMails;
use venditabant::Model::System::Settings;
use venditabant::Helpers::Jwt;

has 'pg';

async sub process($self, $mailer_mails_pkey) {

    my $mail = await $self->load_mail($mailer_mails_pkey);
    my $settings = await $self->load_smtp_settings();

}

async sub load_smtp_settings($self) {
    my $setting = await venditabant::Model::System::Settings->new(
        db => $self->pg->db
    )->load_setting(
        'SMTP'
    );

    my $setting_obj = await venditabant::Helpers::Jwt->new()->decode_jwt_p(
        $setting->{value}
    );

    return $setting_obj;
}

async sub load_mail ($self, $mailer_mails_pkey) {
    return await venditabant::Model::Mail::MailerMails->new(
        db => $self->pg->db
    )->load_mail(
        $mailer_mails_pkey
    );
}
1;