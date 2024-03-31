package venditabant::Controller::Login;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw {from_json};
use Data::Dumper;

sub login_user ($self) {

	say "Login user";
	$self->render_later;

	my $data = from_json($self->req->body);
	$self->login->login_user($data->{username}, $data->{password})->then(sub ($result) {
		say "Place 1 " . Dumper($result);
		if($result) {
			$self->render(json => {'result' => "success", data => $result});
		} else {
			$self->render(json => {'result' => "failed", data => $result});
		}
	})->catch(sub ($err) {
		say "Error " . Dumper($err);
		$self->render(json => {'result' => $err});
	})->wait;
}

1;
