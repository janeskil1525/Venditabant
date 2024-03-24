package Database::Controller::Pglist;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Database::Helper::Common;

sub list($self) {

    $self->render_later;
    my $data = Database::Helper::Common->new($self)->get_basedata();

    say "in pglist";

}
1;