package venditabant::Model::Mail::MailerMailsAttachments;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Files::File;

use DBD::Pg ':pg_types';
use Data::Dumper;

has 'db';

async sub insert($self, $mailer_mails_pkey, $path) {

    my $content = await venditabant::Helpers::Files::File->new()->load_file($path);
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