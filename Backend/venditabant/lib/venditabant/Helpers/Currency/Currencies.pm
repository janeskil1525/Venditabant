package venditabant::Helpers::Currency::Currencies;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Currency::Currencies;

use Data::Dumper;

has 'pg';

async sub load_list ($self, $companies_pkey, $users_pkey) {

    my $hashes = await venditabant::Model::Currency::Currencies->new(
        db => $self->pg->db
    )->load_currency_list($companies_pkey, $users_pkey);

    return $hashes;
}

1;