package Database::Controller::Pglist;
use Mojo::Base 'Mojolicious::Controller', -signatures, -async_await;

use Database::Helper::Common;
use Database::Model::Postgres;;

sub list($self) {

    my $common = Database::Helper::Common->new($self);
    $self->render_later;

    my $table = $self->param('table');

    my $key_value = $self->param('table');

    my $data = $common->get_basedata();
    $self->pgmodel->list($data, $table, $key_value)->then(sub($result){
        $self->render(json => {'result' => 'success', data => $result});
    })-catch(sub($err){
        $self->render(json => {'result' => 'failed', data => $err});
    })->wait();

    say "in pglist";

}
1;