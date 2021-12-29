package Salesorder::Workflow::Action::Create;
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
use Salesorder::Model::Head;
use Salesorder::Helpers::DbFields::Head;
use Salesorder::Model::Workflow;

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();

    my $salesorders_pkey = 0;
    my $context = $wf->context;
    if($context->param('salesorders_pkey') == 0) {
        eval {
            my $db = $pg->db;
            my $tx = $db->begin();

            my $orderno = $self->_get_orderno(
                $db, $context->param('companies_fkey'), $context->param('users_fkey')
            );
            $wf->add_history(
                Workflow::History->new({
                    action      => "New orderno",
                    description => "Order no $orderno created",
                    user        => $context->param('history')->{userid},
                })
            );
            $context->param(orderno => $orderno);

            my $data = $self->_get_data($context);

            $salesorders_pkey = Salesorder::Model::Head->new(db => $db)->upsert(
                $context->param('companies_fkey'), $context->param('users_fkey'), $data
            );
            $wf->add_history(
                Workflow::History->new({
                    action      => "Save order",
                    description => "Order with key $salesorders_pkey and orderno $orderno saved or created",
                    user        => $context->param('history')->{userid},
                })
            );

            Salesorder::Model::Workflow->new(
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
    } else {
        $salesorders_pkey = $context->param('salesorders_pkey');
    }

    return $salesorders_pkey;
}

sub _get_data($self, $context) {

    my $data;
    my $fields = Salesorder::Helpers::DbFields::Head->new->upsert_fields();

    foreach my $field (@{$fields}) {
        $data->{$field} = $context->param($field);
    }

    return $data;
}

sub _get_orderno($self, $db, $companies_fkey, $users_fkey) {

    my $orderno = Engine::Model::Counter->new(
        db => $db
    )->nextid(
        $companies_fkey, $users_fkey, 'salesorder'
    );

    return $orderno;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'SalesordersPersister' )->get_pg();
}

1;