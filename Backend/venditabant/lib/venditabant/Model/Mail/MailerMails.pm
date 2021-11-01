package venditabant::Model::Mail::MailerMails;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub insert ($self, $companies_pkey, $recipients, $subject, $content) {

    my $mailer_mails_pkey = $self->db->insert(
        'mailer_mails',
            {
                companies_fkey => $companies_pkey,
                recipients     => $recipients,
                subject        => $subject,
                content        => $content,
            },
            {
                returning => 'mailer_mails_pkey'
            }
    )->hash->{mailer_mails_pkey};

    return $mailer_mails_pkey;

}

1;