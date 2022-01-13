package Invoice::Workflow::Action::Document;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );

use Document::Helpers::Create;
use Invoice::Helpers::Load;

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();
    my $context = $wf->context;

    if($context->param('invoice_pkey') == 0) {
        # Create invoice document here

        my $data = Invoice::Helpers::Load->new(
            pg => $pg
        )->load_invoice_full(
            $context->param('companies_pkey'),
            $context->param('users_pkey'),
            $context->param('invoice_pkey')
        );

        Document::Helpers::Create->new(
            pg => $pg
        )->create(
            $context->param('companies_pkey'),
            $context->param('users_pkey'),
            $data->{company}->{languages_fkey},
            'Invoice',
            $data
        );
    }

    return $context->param('invoice_pkey');
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'InvoicePersister' )->get_pg();
}

1;