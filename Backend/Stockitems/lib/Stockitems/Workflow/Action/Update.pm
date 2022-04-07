package Stockitems::Workflow::Action::Update;
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

    my $stockitem_data = $context->param('stockitem');

    my $stockitems_fkey = Stockitems->new(
        pg => $pg
    )->upsert (
        $context->param('companies_fkey'),
        $context->param('users_fkey'),
        $stockitem_data
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