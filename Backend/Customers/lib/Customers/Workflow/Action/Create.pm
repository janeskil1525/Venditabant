package Customers::Workflow::Action::Create;
use strict;
use warnings FATAL => 'all';
use base qw( Engine::Workflow::Action::Base );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );

use Customers;
use Customers::Model::Workflow;

sub execute ($self, $wf) {


    my $pg = $self->get_pg('CustomerPersister');
    my $context = $wf->context;

    $wf->add_history(
        Workflow::History->new({
            action      => "New customer",
            description => "Customer  $context->param('customer')->{customer} will be created",
            user        => $context->param('history')->{userid},
        })
    );

    my $customers_pkey = Customers->new(pg => $pg)->upsert(
        $context->param('companies_fkey'), $context->param('users_fkey'), $context->param('customer')
    );

    Customers::Model::Workflow->new(
        db => $pg->db
    )->insert(
        $wf->id, $customers_pkey, $context->param('users_fkey'), $context->param('companies_fkey')
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "New customer created",
            description => "Customer  $context->param('customer')->{customer} was created",
            user        => $context->param('history')->{userid},
        })
    );
}

1;