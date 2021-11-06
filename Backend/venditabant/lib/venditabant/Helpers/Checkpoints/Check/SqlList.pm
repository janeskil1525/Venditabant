package venditabant::Helpers::Checkpoints::Check::SqlList;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

async sub check ($self, $companies_pkey, $check) {


}

1;