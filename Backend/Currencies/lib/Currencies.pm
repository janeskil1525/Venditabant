package Currencies;
use Mojo::Base -base, -signatures, -async_await;

use Currencies::Helpers::Currencies;
use Currencies::Helpers::Exchangerates;

our $VERSION = '0.04';

has 'pg';

async sub upsert_exchangerate_p($self, $exchangerate) {
    return Currencies::Helpers::Exchangerates->new(
        pg => $self->pg
    )->upsert_p(
        $exchangerate
    );
}

async sub upsert_currency_p($self, $currency) {
    return Currencies::Helpers::Currencies->new(
        pg => $self->pg
    )->upsert_p(
        $currency
    );
}

async sub load_currency_list_p($self, $companies_pkey, $users_pkey) {
    return Currencies::Helpers::Currencies->new(
        pg => $self->pg
    )->load_currency_list_p(
        $companies_pkey, $users_pkey
    );
}

async sub load_currency_pkey_p($self, $shortdescription) {
    return Currencies::Helpers::Currencies->new(
        pg => $self->pg
    )->load_currency_pkey_p(
        $shortdescription
    );
}

sub load_currency_pkey($self, $shortdescription) {
    return Currencies::Helpers::Currencies->new(
        pg => $self->pg
    )->load_currency_pkey(
        $shortdescription
    );
}

async sub load_list_p($self, $companies_pkey, $users_pkey) {
    return Currencies::Helpers::Currencies->new(
        pg => $self->pg
    )->load_list_p(
        $companies_pkey, $users_pkey
    );
}


1;