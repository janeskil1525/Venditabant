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

    if($context->param('invoice_fkey') > 0) {
        # Create invoice document here
        $wf->add_history(
            Workflow::History->new({
                action      => "Create document started",
                description => "Documents for invoice with key $context->param('invoice_fkey') creation process started",
                user        => $context->param('history')->{userid},
            })
        );

        my $data = Invoice::Helpers::Load->new(
            pg => $pg
        )->load_invoice_full(
            $context->param('companies_fkey'),
            $context->param('users_fkey'),
            $context->param('invoice_fkey')
        );

        $wf->add_history(
            Workflow::History->new({
                action      => "Create document invoice loaded",
                description => "Loaded full invoice with key $context->param('invoice_fkey') ",
                user        => $context->param('history')->{userid},
            })
        );

        Document::Helpers::Create->new(
            pg => $pg
        )->create(
            $context->param('companies_fkey'),
            $context->param('users_fkey'),
            $data->{company}->{languages_fkey},
            'Invoice',
            $data
        );

        $wf->add_history(
            Workflow::History->new({
                action      => "document created for invoice",
                description => "Documents created for invoice with key $context->param('invoice_fkey') ",
                user        => $context->param('history')->{userid},
            })
        );
    }

    return $context->param('invoice_fkey');
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'InvoicePersister' )->get_pg();
}

1;