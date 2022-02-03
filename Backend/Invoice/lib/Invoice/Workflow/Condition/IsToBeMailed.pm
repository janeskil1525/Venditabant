package Invoice::Workflow::Condition::IsToBeMailed;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Condition );
no warnings  'experimental';

use feature 'signatures';
use Workflow::Exception qw( condition_error configuration_error );
use Workflow::Factory qw( FACTORY );

__PACKAGE__->mk_accessors( 'mail' );

sub _init {
    my ( $self, $params ) = @_;
    $params->{mail}  unless $params->{mail};

}

sub evaluate {
    my ( $self, $wf ) = @_;

    my $pg = $self->get_pg();
    my $result = $pg->db->select(
        ['invoice',
            ['customer_addresses', 'invoice.customers_fkey' => 'customer_addresses.customers_fkey']],
            ['mail_invoice'],
            {
                invoice_pkey => $wf->context->param('invoice_fkey'),
                type         => 'INVOICE',
            }
    );

    $self->mail(0);

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;
    if(exists $hash->{mail_invoice}) {
        $self->mail($hash->{mail_invoice});
    } else {
        condition_error "Mail invoice parameter missing";
    }
    return $hash;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'InvoicePersister' )->get_pg();
}
1;