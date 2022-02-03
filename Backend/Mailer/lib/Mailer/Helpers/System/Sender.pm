package Mailer::Helpers::Mailer::System::Sender;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::System::Settings;
use venditabant::Model::Mail::MailerMails;

use Try::Tiny;
use Email::Stuffer;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP;
use Email::Simple;
use Email::MIME;

has 'pg';

async sub _send($self, $settings, $mail ) {

    my $err;
    eval {
        my $transport = Email::Sender::Transport::SMTP->new({
            host          => $settings->{host},
            port          => $settings->{port},
            ssl           => $settings->{ssl},
            sasl_username => $settings->{sasl_username},
            sasl_password => $settings->{sasl_password},
        });

        Email::Stuffer->to('Jan Eskilsson<janeskil1525@gmail.com>')
            ->from('admin@venditabant.net')
            #->text_body("You've been good this year. No coal for you.")
            ->html_body($mail->{content})
            #->attach_file('choochoo.gif')
            ->transport($transport)
            ->subject($mail->{subject})
            ->send;
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Mailer::System::Sender', '_send', $err
    ) if $err;

    return $err ? $err : '1' ;
}1;