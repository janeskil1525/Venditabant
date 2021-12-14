package Engine::Helpers::Salesorder::Processor::Create;
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
use Engine::Helpers::Salesorder::DbFields::Head;
use Engine::Model::Salesorder::Workflow;

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();

    my $salesorders_pkey = 0;
    my $context = $wf->context;
    if($context->param('salesorders_pkey') == 0) {
        eval {
            my $db = $pg->db;
            my $tx = $db->begin();
            my $orderno = Engine::Model::Counter->new(
                db => $db
            )->nextid(
                $context->param('companies_fkey'), $context->param('users_fkey'), 'salesorder'
            );
            $context->param(orderno => $orderno);
            my $fields = Engine::Helpers::Salesorder::DbFields::Head->new->upsert_fields();

            my $data;
            foreach my $field (@{$fields}) {
                $data->{$field} = $context->param($field);
            }

            $salesorders_pkey = Engine::Model::Salesorder::Head->new(db => $db)->upsert(
                $context->param('companies_fkey'), $context->param('users_fkey'), $data
            );
            Engine::Model::Salesorder::Workflow->new(
                db => $db
            )->upsert(
                $wf->id, $salesorders_pkey
            );

            $tx->commit();
            $context->param(salesorders_pkey => $salesorders_pkey);
        };
        if ( $@ ) {
            workflow_error
                "Cannot create new salesorder for customer '", $context->param( 'company_fkey' ), "': $@";
        }
    }

    return $salesorders_pkey;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'SalesordersPersister' )->get_pg();
}

1;