package Invoice::Model::Mails;
use Mojo::Base -base, -signatures;


has 'db';

sub insert($self, $mailer_mails_fkey, $invoice_fkey) {

    $self->db->insert(
        'mails_invoice',
            {
                mailer_mails_fkey => $mailer_mails_fkey,
                invoice_fkey      => $invoice_fkey
            }
    );
}
1;