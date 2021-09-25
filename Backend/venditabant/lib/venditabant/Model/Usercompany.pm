package venditabant::Model::Usercompany;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -base, -signatures, -async_await;

has 'pg';
has 'db';

sub insert ($self, $data) {

}
1;