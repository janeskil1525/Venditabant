package Mailer::Model::MailerMails;
use Mojo::Base -base, -signatures, -async_await;

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

async sub load_mail ($self, $mailer_mails_pkey) {

    my $result = $self->db->select(
        'mailer_mails', ['*'],
            {
                mailer_mails_pkey => $mailer_mails_pkey
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows() > 0;

    return $hash;
}

async sub set_sent($self, $mailer_mails_pkey) {

    $self->db->update(
        'mailer_mails',
            {
                sent => 'true',
                sent_at => 'now()',
            },
        {
            mailer_mails_pkey => $mailer_mails_pkey
        }
    );

    return 1;
}
1;