package Engine::Prelude::Salesorder;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'pg';

async sub prelude($workflow, $data) {

}
1;