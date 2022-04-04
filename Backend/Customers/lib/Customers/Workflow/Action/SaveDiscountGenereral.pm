package Customers::Workflow::Action::SaveDiscountGenereral;
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

    my $result = Customers->new(
        pg => $pg
    )->save_general_discount(
        $context->param('companies_fkey'), $context->param('users_fkey'), $context->param('discount')
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "General discount",
            description => "General discount added",
            user        => $context->param('history')->{userid},
        })
    );

    return $result
}
1;