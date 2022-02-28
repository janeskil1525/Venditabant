package Mailer::Helpers::Sender;
use Mojo::Base -base, -signatures;

use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP;
use Email::Simple;
use Email::MIME;

use Mailer::Model::MailerMails;
use System::Model::Settings;

has 'pg';
has 'server_adress';
has 'smtp';
has 'account';
has 'passwd';


sub process($self, $mailer_mails_pkey) {

    my $mail = $self->_load_mail($mailer_mails_pkey);
    my $settings = $self->_load_smtp_settings();
    my $mailed = $self->_send_mail( $mail);

    if($mailed eq '1') {
        $self->_set_mail_sent($mailer_mails_pkey)
    }

    return 1;
}

sub _set_mail_sent($self, $mailer_mails_pkey) {

    my $err;
    eval {
        Model::MailerMails->new(
            db => $self->pg->db
        )->set_sent(
            $mailer_mails_pkey
        );
    };
    $err = $@ if $@;

    return '1' unless $err;
    return $err;
}

sub _load_smtp_settings ($self) {

    my $setting = System::Helpers::Settings->new(
        pg => $self->pg
    )->load_system_setting(
        0,0,'SMTP'
    );
    $self->server_adress($setting->{value}->{server_adress});
    $self->smtp($setting->{value}->{smtp});
    $self->account($setting->{value}->{account});
    $self->passwd($setting->{value}->{passwd});
    return $setting;
}

sub _load_mail ($self, $mailer_mails_pkey) {
    return Model::MailerMails->new(
        db => $self->pg->db
    )->load_mail(
        $mailer_mails_pkey
    );
}


sub _send_mail{
    my ($self, $to, $subject, $attachment) = @_;

    my @parts;
    my $length = scalar @{$attachment};
    for (my $i = 0; $i < $length; $i++){

        push @parts,  Email::MIME->create(
            attributes => {
                content_type => @{$attachment}[$i]->{type},
                disposition  => "attachment",
                charset      => "US-ASCII",
                encoding     => 'base64',
                encode_check => 0,
            },
            body_str => @{$attachment}[$i]->{data},
        );
    }

    my $email = Email::MIME->create(
        header_str     => [
            From           => $self->account,
            To             => $to,
            Subject        => $subject,
        ],
        parts => [@parts],
    );

    my $transport = Email::Sender::Transport::SMTP->new({
        host          => $self->smtp,
        port          => 587,
        ssl           => 'starttls',
        sasl_username => $self->account,
        sasl_password => $self->passwd,
    });

    my $result = try {
        sendmail($email, {
            transport => $transport
        });
        return 1;
    } catch {
        say $_;
        return $_;
    };

    return $result;
}

sub _get_attachement{
    my ($self, $attachement, $type, $data) = @_;

    $type = 'text/html' unless $type;

    my $att;
    $att->{type} = $type;
    $att->{data} = $data;
    push @{$attachement}, $att;

    return $attachement;
}

1;