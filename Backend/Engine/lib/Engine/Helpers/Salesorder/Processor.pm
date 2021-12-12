package Engine::Helpers::Salesorder::Processor;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Exception qw( workflow_error );

sub create_order ($self, $wf) {
    my $context = $wf->context;



}

sub close_order ($self, $wf) {
    my $context = $wf->context;



}

sub invoice_order ($self, $wf) {
    my $context = $wf->context;



}

sub archive_order ($self, $wf) {
    my $context = $wf->context;



}
1;