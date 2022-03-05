package Mailer::Model::MailerMailsAttachments;
use Mojo::Base -base, -signatures, -async_await;

use Mailer::Helpers::File;

use DBD::Pg ':pg_types';
use Data::Dumper;

has 'db';

sub insert($self, $mailer_mails_pkey, $path) {

    my $content = Mailer::Helpers::File->new()->load_file($path);
    my $stmt = qq {
        INSERT INTO mailer_mails_attachements (mailer_mails_fkey, path, file)
            VALUES (?, ?, ?)
    };

    $self->db->query(
        $stmt,
        ($mailer_mails_pkey, $path,
            { type => PG_BYTEA, value => $content }
        )
    );
}

async sub insert_p($self, $mailer_mails_pkey, $path) {

    my $content = await Mailer::Helpers::File->new()->load_file($path);
    my $stmt = qq {
        INSERT INTO mailer_mails_attachements (mailer_mails_fkey, path, file)
            VALUES (?, ?, ?)
    };

    $self->db->query(
        $stmt,
            ($mailer_mails_pkey, $path,
                { type => PG_BYTEA, value => $content }
            )
    );
}
1;