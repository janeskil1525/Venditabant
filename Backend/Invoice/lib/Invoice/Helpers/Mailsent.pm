package Invoice::Helpers::Mailsent;
use Mojo::Base -base, -signatures;

use Data::Dumper;

has 'pg';

sub set_as_sent ($self, $mailer_mails_fkey) {

    my $stmt = qq{
        INSERT INTO invoice_status (invoice_fkey, status)
            VALUES ((SELECT invoice_fkey FROM mails_invoice WHERE mailer_mails_fkey = ?),'SENT')
        ON CONFLICT (invoice_fkey, status) DO UPDATE
            SET moddatetime = now()
        RETURNING invoice_status_pkey;
    };

    my $hash;
    my $err;

    eval {
        my $result = $self->pg->db->query($stmt,($mailer_mails_fkey));
        $hash = $result->hash if $result and $result->rows() > 0;
    };
    $err = $@ if $@;
    say $err;

    return exists $hash->{invoice_status_pkey};
}

1;