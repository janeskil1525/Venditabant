package Engine::Workflow::Observers::AddTodo;
use Mojo::Base -base, -signatures;

use Workflow::Factory qw(FACTORY);

sub update($class, $wf, $event, $new_state) {

    return unless ( $event eq 'state change' );
    return unless ( $new_state eq 'Invoice Created' );
    my $context = $wf->context;


}

sub get_pg($self) {
    return  FACTORY->get_persister( 'TransitPersister' )->get_pg();
}
1;