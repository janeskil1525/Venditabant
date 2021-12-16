package Engine::Helpers::Salesorder::Processor::Items;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::Exception qw( workflow_error );
use Workflow::History;

use Engine::Model::Counter;
use Engine::Model::Salesorder::Head;
use Engine::Model::Salesorder::Item;


sub execute ($self, $wf) {

    my $pg = $self->get_pg();

    my $context = $wf->context;
    my $items = $context->param('items');

    foreach my $item (@{$items}) {
        $item->{salesorders_fkey} = $context->param('salesorders_pkey');
        $self->item_upsert(
            $context->param('companies_fkey'), $context->param('users_fkey'), $item, $pg);
        $wf->add_history(
            Workflow::History->new({
                action      => "Save item",
                description => "Stockitem $item->{stockitem} saved or created",
                user        => $context->param('history')->{userid},
            })
        );
    }
}

sub item_upsert($self, $companies_pkey, $users_pkey, $data, $pg) {

    my $db = $pg->db;
    my $tx = $db->begin();
    my $log = Log::Log4perl->get_logger();

    my $err;
    my $salesorder_items_pkey;
    eval {

        if($data->{quantity} > 0) {

            $salesorder_items_pkey = Engine::Model::Salesorder::Item->new(
                db => $db
            )->upsert(
                $companies_pkey, $data->{salesorders_fkey}, $users_pkey, $data
            );
        } else {
            $salesorder_items_pkey = Engine::Model::Salesorder::Item->new(
                db => $db
            )->delete_item(
                $companies_pkey, $data->{salesorders_fkey}, $data
            );
        }

        $tx->commit();
    };
    $err = $@ if $@;
    $log->error(
        "Engine::Helpers::Salesorder::Processor::Items " . $err
    ) if $err;

    return $err ? $err : $salesorder_items_pkey;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'SalesordersPersister' )->get_pg();
}
1;