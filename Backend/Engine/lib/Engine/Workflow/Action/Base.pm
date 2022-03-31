package Engine::Workflow::Action::Base;
use strict;
use warnings FATAL => 'all';

use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Workflow::Factory qw( FACTORY );
use Workflow::Exception qw( workflow_error );


sub get_pg($self, $persister) {
    return  FACTORY->get_persister( $persister )->get_pg();
}
1;