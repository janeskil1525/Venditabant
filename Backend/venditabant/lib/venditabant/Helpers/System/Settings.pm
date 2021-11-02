package venditabant::Helpers::System::Settings;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $users_pkey, $data) {

}
1;