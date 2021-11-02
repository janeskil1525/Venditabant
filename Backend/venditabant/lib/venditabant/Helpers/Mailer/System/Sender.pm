package venditabant::Helpers::Mailer::System::Sender;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Try::Tiny;
use Email::Stuffer;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP;
use Email::Simple;
use Email::MIME;

has 'pg';

async sub process($self, $mailer_mails_pkey) {

    my @parts;
    my $transport = Email::Sender::Transport::SMTP->new({
        host          => 'smtp.office365.com',
        port          => 587,
        ssl           => 'starttls',
        sasl_username => 'admin@venditabant.net',
        sasl_password => 'PeTer1"%09',
    });

    # push @parts,  Email::MIME->create(
    #     attributes => {
    #         content_type => 'text/html',
    #         disposition  => "attachment",
    #         charset      => "US-ASCII",
    #         encoding     => 'base64',
    #         encode_check => 0,
    #     },
    #     body_str => 'Hej hopp',
    # );
    #
    # my $email = Email::MIME->create(
    #     header_str     => [
    #         From           => 'jan@daje.work',
    #         To             => 'janeskil1525@gmail.com',
    #         Subject        => 'Test',
    #     ],
    #     parts => [@parts],
    # );
    #
    # my $result = try {
    #     sendmail($email, {
    #         transport => $transport
    #     });
    #     return 1;
    # } catch {
    #     say $_;
    #     return 0;
    # };

    #return $result;
     try {
         Email::Stuffer->to('Jan Eskilsson<janeskil1525@gmail.com>')
             ->from('jan@daje.work')
             #->text_body("You've been good this year. No coal for you.")
             ->html_body($mailer_mails_pkey)
             #->attach_file('choochoo.gif')
             ->transport($transport)
             ->subject('Test')
             ->send;
     } catch {
         die "Error sending email: $_";
     };
     print $@ if $@;
}1;