package Engine::Helpers::Salesorder::Processor::Items;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::Exception qw( workflow_error );

use Engine::Model::Counter;
use Engine::Model::Salesorder::Head;

sub execute ($self, $wf) {

    my $pg = $self->get_pg();

    my $context = $wf->context;
    my $items = $context->param('items');

    foreach my $item (@{$items}) {
        $self->item_upsert(
            $context->param('companies_fkey'), $context->param('users_fkey'), $item)
    }
}

sub item_upsert($self, $companies_pkey, $users_pkey, $data) {

    my $db = $self->pg->db;
    my $tx = $db->begin();
    my $log = Log::Log4perl->get_logger();

    my $err;
    eval {

        if($data->{quantity} > 0) {

            Engine::Model::Salesorder::Item->new(
                db => $db
            )->upsert(
                $companies_pkey, $data->{salesorders_fkey}, $users_pkey, $data
            );
        } else {
            Engine::Model::Salesorder::Item->new(
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


    return $err ? $err : 'success';
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'SalesordersPersister' )->get_pg();
}
1;