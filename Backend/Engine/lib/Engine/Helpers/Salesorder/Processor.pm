package Engine::Helpers::Salesorder::Processor;
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

sub execute()


sub close_order ($self, $wf) {
    my $context = $wf->context;



}

sub invoice_order ($self, $wf) {
    my $context = $wf->context;



}

sub archive_order ($self, $wf) {
    my $context = $wf->context;



}

sub get_pg($self) {
    return  FACTORY->get_persister( 'SalesordersPersister' )->get_pg();
}
1;