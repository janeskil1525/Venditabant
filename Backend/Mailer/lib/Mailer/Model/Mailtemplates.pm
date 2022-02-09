package Mailer::Model::Mailtemplates;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

sub update ($self, $companies_pkey, $users_pkey, $template) {
    my $stmt = qq{
        UPDATE default_mailer_mails SET header_value = ?, body_value = ?, footer_value = ?,
            moddatetime = now(),
            modby = (SELECT userid FROM users WHERE users_pkey = ?), sub1 = ?, sub2 = ?, sub3 = ?
            WHERE default_mailer_mails_pkey = ?
        RETURNING default_mailer_mails_pkey
    };

    my $default_mailer_mails_pkey = $self->db->query(
        $stmt,
        (
            $template->{header_value},
            $template->{body_value},
            $template->{footer_value},
            $users_pkey,
            $template->{sub1},
            $template->{sub2},
            $template->{sub3},
            $template->{default_mailer_mails_pkey}

        )
    )->hash->{default_mailer_mails_pkey};

    return $default_mailer_mails_pkey;
}

sub upsert ($self, $companies_pkey, $users_pkey, $template) {

    my $stmt = qq{
        INSERT INTO default_mailer_mails (insby, modby, mailer_fkey, languages_fkey, header_value,
                body_value, footer_value, sub1, sub2, sub3)
            VALUES ((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?,?,?,?,?,?)
            ON CONFLICT (mailer_fkey, languages_fkey)
        DO UPDATE SET header_value = ?, body_value = ?, footer_value = ?,
            moddatetime = now(),
            modby = (SELECT userid FROM users WHERE users_pkey = ?)
        RETURNING default_mailer_mails_pkey
    };

    my $default_mailer_mails_pkey = $self->db->query(
        $stmt,
        (
            $users_pkey,
            $users_pkey,
            $template->{mailer_fkey},
            $template->{languages_fkey},
            $template->{header_value},
            $template->{body_value},
            $template->{footer_value},
            $template->{sub1},
            $template->{sub2},
            $template->{sub3},
            $template->{header_value},
            $template->{body_value},
            $template->{footer_value},
            $users_pkey,
        )
    )->hash->{default_mailer_mails_pkey};

    return $default_mailer_mails_pkey;
}

sub load_mailer_list ($self) {
    my $result = $self->db->select(
        'mailer','*', undef,
        {
            order_by => 'mailtemplate',
        }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}

sub load_list ($self, $mailer_pkey) {
    my $result = $self->db->select(
        ['default_mailer_mails',
            ['languages', 'languages_pkey' => 'languages_fkey']],
        ['default_mailer_mails_pkey', 'header_value', 'body_value', 'footer_value', 'lan', 'languages_fkey', 'sub1', 'sub2', 'sub3'],
            {
                mailer_fkey => $mailer_pkey
            },
        {
             order_by => 'languages_fkey',
        }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}

async sub load_template_p($self, $companies_pkey, $users_pkey, $language_fkey, $template) {

    my $result = $self->db->select(
        ['default_mailer_mails',
            ['mailer', 'mailer_pkey' => 'mailer_fkey']],
        ['header_value', 'body_value', 'footer_value','sub1', 'sub2', 'sub3'],
        {
            languages_fkey => $language_fkey,
            mailtemplate       => $template,
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash
}

sub load_template($self, $companies_pkey, $users_pkey, $language_fkey, $template) {

    my $result = $self->db->select(
        ['default_mailer_mails',
            ['mailer', 'mailer_pkey' => 'mailer_fkey']],
        ['header_value', 'body_value', 'footer_value','sub1', 'sub2', 'sub3'],
        {
            languages_fkey => $language_fkey,
            mailtemplate       => $template,
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash
}
1;