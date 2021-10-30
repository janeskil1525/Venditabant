package venditabant::Helpers::Mailer::Mails::Attachement::Pdf;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;
use PDF::FromHTML;

has 'db';

async sub create($self, $companies_pkey, $users_pkey, $html, $filename) {


}

1;