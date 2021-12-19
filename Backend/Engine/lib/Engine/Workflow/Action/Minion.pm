package Engine::Workflow::Action::Minion;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::Exception qw( workflow_error );

use Minion;

sub execute($self, $wf) {

    my $pg = $self->get_pg();

    my $params = $wf->context->param;

    my $minion;
    while ( my ( $k, $v ) = each %{ $params } ) {
        if($k ne 'minion' and $k ne 'history') {
            $minion->{$k} = $v;
        }
    }

    my $min = Minion->new(Pg => $pg);
    $min->enqueue(
        $minion->{minion} => [$minion] => {
            priority => 0,
        }
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "Invoice order",
            description => "$minion->{minion} $minion->{companies_pkey} $minion->{salesorders_pkey}",
            user        => $wf->context->param('history')->{userid},
        })
    );
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'SalesordersPersister' )->get_pg();
}
1;