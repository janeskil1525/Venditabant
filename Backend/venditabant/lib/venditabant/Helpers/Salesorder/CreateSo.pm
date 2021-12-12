package venditabant::Helpers::Salesorder::CreateSo;
use Mojo::Base 'Workflow::Action', -signatures, -async_await;

use Data::Dumper;
use Workflow::Exception qw( workflow_error );

has 'pg';

sub create_order ($self, $wf) {
    my $context = $wf->context;



}
1;