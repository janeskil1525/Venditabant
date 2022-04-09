package Pricelists::Workflow::Action::Create;
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
use Pricelists::Model::Workflow;

sub execute ($self, $wf) {

    my $pg = $self->get_pg('PricelistPersister');
    my $context = $wf->context;

    my $pricelist = $context->param('pricelist')->{pricelist};
    $wf->add_history(
        Workflow::History->new({
            action      => "New pricelist",
            description => "Pricelist $pricelist will be created",
            user        => $context->param('history')->{userid},
        })
    );

    my $pricelists_pkey = Pricelists->new(pg => $pg)->upsert_head (
        $context->param('companies_fkey'), $context->param('users_fkey'), $context->param('pricelist')
    );

    Pricelists::Model::Workflow->new(
        db => $pg->db
    )->insert(
        $wf->id, $pricelists_pkey, $context->param('users_fkey'), $context->param('companies_fkey')
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "New pricelist created",
            description => "Pricelist $pricelist was created",
            user        => $context->param('history')->{userid},
        })
    );

    return $pricelists_pkey;
}

1;