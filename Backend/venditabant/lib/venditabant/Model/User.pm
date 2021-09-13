package venditabant::Model::User;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

has 'pg';
has 'db';

sub insert ($self, $data) {

}
1;