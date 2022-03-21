package Mailer::Helpers::Dependencies;
use Mojo::Base -base, -signatures;

use Invoice::Model::Mails;

has 'pg';

sub create_dependencies($self, $mails_invoice_fkey, $context) {

    if($context->param('invoice_fkey') and $context->param('invoice_fkey') > 0) {
        Invoice::Model::Mails->new(
            db => $self->pg->db
        )->insert(
            $mails_invoice_fkey, $context->param('invoice_fkey')
        );
    } # Else if something here

}

1;