package Customers::Workflow::Action::Update;
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

sub execute ($self, $wf) {

    my $pg = $self->get_pg('CustomerPersister');
    my $context = $wf->context;


    my $customers_pkey = Customers->new(pg => $pg)->upsert(
        $context->param('companies_fkey'), $context->param('users_fkey'), $context->param('customer')
    );

    my $customer = $context->param('customer')->{customer};

    $wf->add_history(
        Workflow::History->new({
            action      => "Update customer",
            description => "Customer $customer was created",
            user        => $context->param('history')->{userid},
        })
    );

    return $customers_pkey;
}

1;