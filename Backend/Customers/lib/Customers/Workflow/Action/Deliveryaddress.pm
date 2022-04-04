package Customers::Workflow::Action::Deliveryaddress;
use strict;
use warnings FATAL => 'all';
use base qw( Engine::Workflow::Action::Base );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );


sub execute ($self, $wf) {

    my $pg = $self->get_pg('CustomerPersister');
    my $context = $wf->context;

    my $result = Customers->new(
        pg => $pg
    )->upsert_address(
        $context->param('companies_fkey'),
        $context->param('users_fkey'),
        $context->param('address')
    );

    my $name = $context->param('address')->{name};
    $wf->add_history(
        Workflow::History->new({
            action      => "Delivery address",
            description => "Delivery adddress for $name updated",
            user        => $context->param('history')->{userid},
        })
    );

    return $result;


}

1;