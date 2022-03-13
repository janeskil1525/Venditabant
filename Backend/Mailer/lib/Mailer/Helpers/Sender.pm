package Mailer::Helpers::Sender;
use Mojo::Base -base, -signatures;

use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP;
use Email::Simple;
use Email::MIME;
use IO::All;

use Mailer::Model::MailerMails;
use Mailer::Model::MailerMailsAttachments;
use System::Model::Settings;

has 'pg';
has 'host';
has 'account';
has 'passwd';


sub process($self, $mailer_mails_pkey) {

    my $mail = $self->_load_mail ($mailer_mails_pkey);
    my $attachements = $self->_load_attachements ($mailer_mails_pkey);

    my $mailed = $self->_send_mail($mail->{recipients}, $mail->{subject}, $mail->{content}, $attachements);

    if($mailed eq '1') {
        $self->_set_mail_sent($mailer_mails_pkey)
    }

    return 1;
}

sub _load_attachements ($self, $mailer_mails_pkey) {

    my $attachements = Mailer::Model::MailerMailsAttachments->new(
        db => $self->pg->db
    )->load(
        $mailer_mails_pkey
    );

    return $attachements;
}

sub _set_mail_sent ($self, $mailer_mails_pkey) {

    my $err;
    eval {
        Mailer::Model::MailerMails->new(
            db => $self->pg->db
        )->set_sent(
            $mailer_mails_pkey
        );
    };
    $err = $@ if $@;

    return '1' unless $err;
    return $err;
}

sub _load_mail ($self, $mailer_mails_pkey) {
    return Mailer::Model::MailerMails->new(
        db => $self->pg->db
    )->load_mail(
        $mailer_mails_pkey
    );
}


sub _send_mail($self, $to, $subject, $content, $attachments) {

    my @parts;

    push @parts,  Email::MIME->create(
        attributes => {
            content_type => 'text/plain',
            disposition  => "body",
            charset      => "utf-8",
            encoding     => "base64",
            encode_check => 0,
        },
        body_str => $content,
    );
    
    foreach my $attachement (@{$attachments}) {

        push @parts,  Email::MIME->create(
            attributes => {
                content_type => "application/pdf",
                encoding     => "base64",
                filename     => 'invoice.pdf',
                name         => 'invoice.pdf'
            },
            body => io( $attachement->{path} )->binary->all,
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
        host          => $self->host,
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