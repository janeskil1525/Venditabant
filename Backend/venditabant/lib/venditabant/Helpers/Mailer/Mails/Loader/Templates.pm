package venditabant::Helpers::Mailer::Mails::Loader::Templates;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'pg';

async sub load_template($self, $companies_pkey, $users_pkey, $template) {

}
1;