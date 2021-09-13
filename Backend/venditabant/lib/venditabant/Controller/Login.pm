package venditabant::Controller::Login;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw {from_json};
use Data::Dumper;

sub login_user ($self) {

	$self->render_later;
	say 'login_user';
	my $data = from_json($self->req->body);

	$self->login->login_user($data->{username}, $data->{password})->then(sub ($result) {
		say Dumper($result);
		if($result) {
			$self->render(json => {'result' => "success", data => $result});
		} else {
			$self->render(json => {'result' => "failed", data => $result});
		}
	})->catch(sub ($err) {
		$self->render(json => {'result' => $err});
	})->wait;

}

1;
