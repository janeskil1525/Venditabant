package Currencies::Helpers::Exchangerates;
use Mojo::Base -base, -signatures, -async_await;

use Currencies::Model::Exchangerates;

use Data::Dumper;

has 'pg';

async sub upsert_p($self, $exchangerate) {

    return Currencies::Model::Exchangerates->new(
        pg => $self->pg
    )->upsert_p(
        $exchangerate
    );
}
1;