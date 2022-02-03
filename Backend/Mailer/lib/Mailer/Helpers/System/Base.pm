package Mailer::Helpers::Mailer::System::Base;
use Mojo::Base 'Daje::Utils::Sentinelsender';


use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP;
use Email::Simple;
use Email::MIME;

has 'pg';
has 'server_adress';
has 'smtp';
has 'account';
has 'passwd';

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
        $self->capture_message('','Daje::Mailer::Base::Common', (ref $self), (caller(0))[3], $_);
        say $_;
        return 0;
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