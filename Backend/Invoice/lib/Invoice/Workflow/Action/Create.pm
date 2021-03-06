package Invoice::Workflow::Action::Create;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );

use Invoice::Model::Workflow;

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();
    my $context = $wf->context;

    if($context->param('invoice_pkey') > 0) {
        # Create invoice here
        Invoice::Model::Workflow->new(
            db => $pg->db
        )->insert(
            $wf->id,
            $context->param('invoice_pkey'),
            $context->param('users_pkey'),
            $context->param('companies_pkey')
        );

        $wf->add_history(
            Workflow::History->new({
                action      => "New orderno",
                description => "Order no $context->param('invoice_pkey') created",
                user        => $context->param('history')->{userid},
            })
        );
    }

    return $context->param('invoice_pkey');
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'InvoicePersister' )->get_pg();
}
1;