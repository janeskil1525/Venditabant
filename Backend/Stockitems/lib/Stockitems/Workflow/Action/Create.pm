package Stockitems::Workflow::Action::Create;
use strict;
use warnings FATAL => 'all';
use base qw( Engine::Workflow::Action::Base );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );

use Stockitems;

sub execute ($self, $wf) {

    my $pg = $self->get_pg('StockitemPersister');
    my $context = $wf->context;

    my $stockitem = $context->param('stockitem')->{stockitem};
    $wf->add_history(
        Workflow::History->new({
            action      => "New stockitem",
            description => "Stockitem $stockitem will be created",
            user        => $context->param('history')->{userid},

        })
    );

    my $stockitem_data = $context->param('stockitem');
    my $stock = Stockitems->new(pg => $pg);
    my $stockitems_fkey = $stock->upsert (
        $context->param('companies_fkey'),
        $context->param('users_fkey'),
        $stockitem_data
    );

    $stock->insert_workflow(
        $wf->id,
        $stockitems_fkey,
        $context->param('companies_fkey'),
        $context->param('users_fkey')
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "Stockitem created",
            description => "Stockitem $stockitem was created",
            user        => $context->param('history')->{userid},

        })
    );

    return $stockitems_fkey;
}
1;