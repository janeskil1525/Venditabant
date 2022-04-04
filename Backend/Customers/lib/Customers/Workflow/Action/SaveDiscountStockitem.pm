package Customers::Workflow::Action::SaveDiscountStockitem;
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
    )->save_stockitem_discount(
        $context->param('companies_fkey'), $context->param('users_fkey'), $context->param('discount')
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "Stockitem discount",
            description => "Stockitem discount added",
            user        => $context->param('history')->{userid},
        })
    );

    return $result
}

1;