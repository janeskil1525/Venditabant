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

    my $pricelist = $context->param('pricelist')->{'pricelist'};
    my $stockitem = $context->param('pricelist')->{'stockitem'};
    my $price = $context->param('pricelist')->{'price'};
    my $from = $context->param('pricelist')->{'fromdate'};

    my $pricelists_pkey = Pricelists->new(pg => $pg)->insert_item(
        $context->param('companies_fkey'), $context->param('users_fkey'), $context->param('pricelist')
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "Pricelist $pricelist updated",
            description => "Pricelist $pricelist was updated stockitem $stockitem has the price $price from $from",
            user        => $context->param('history')->{userid},
        })
    );
}
1;