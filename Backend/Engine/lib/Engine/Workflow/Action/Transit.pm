package Engine::Workflow::Action::Transit;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';
use feature 'say';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::Exception qw( workflow_error );
use Mojo::JSON qw{encode_json};

use Engine::Model::Transit;

sub execute($self, $wf) {

    my $pg = $self->get_pg();

    my $params = $wf->context->param;

    my $data->{payload} = encode_json $params->{payload};
    $data->{type} = $params->{type};
    $data->{activity} = $params->{activity};
    $data->{users_pkey} = $params->{users_pkey};
    $data->{status} = 0;

    my $transit_pkey = Engine::Model::Transit->new(db => $pg->db)->insert($data);

    return $transit_pkey;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'TransitPersister' )->get_pg();
}
1;