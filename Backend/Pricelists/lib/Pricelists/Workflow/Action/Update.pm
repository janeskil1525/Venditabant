package Pricelists::Workflow::Action::Update;
use strict;
use warnings FATAL => 'all';
use base qw( Engine::Workflow::Action::Base );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );

use Pricelists;

sub execute ($self, $wf) {

    my $pg = $self->get_pg('PricelistPersister');
    my $context = $wf->context;


    my $pricelists_pkey = Pricelists->new(pg => $pg)->insert_item(
        $context->param('companies_fkey'), $context->param('users_fkey'), $context->param('pricelist_item')
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "Pricelist created",
            description => "Pricelist $pricelist was created",
            user        => $context->param('history')->{userid},
        })
    );
}
1;