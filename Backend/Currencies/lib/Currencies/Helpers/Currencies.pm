package Currencies::Helpers::Currencies;
use Mojo::Base -base, -signatures, -async_await;

use Currencies::Model::Currencies;

use Data::Dumper;

has 'pg';

async sub load_currency_pkey($self, $shortdescription) {
    my $hashes = Currencies::Model::Currencies->new(
        db => $self->pg->db
    )->load_currency_pkey(
        $shortdescription
    );

    return $hashes;
}

async sub load_currency_pkey_p($self, $shortdescription) {
    my $hashes = await Currencies::Model::Currencies->new(
        db => $self->pg->db
    )->load_currency_pkey_p(
        $shortdescription
    );

    return $hashes;
}

async sub load_currency_list_p($self, $companies_pkey, $users_pkey) {
    my $hashes = await Currencies::Model::Currencies->new(
        db => $self->pg->db
    )->load_currency_list_p(
        $companies_pkey, $users_pkey
    );

    return $hashes;
}

async sub upsert_p($self, $currency) {
    my $hashes = await Currencies::Model::Currencies->new(
        db => $self->pg->db
    )->upsert_p($currency);

    return $hashes;
}

async sub load_list_p ($self, $companies_pkey, $users_pkey) {

    my $hashes = await Currencies::Model::Currencies->new(
        db => $self->pg->db
    )->load_currency_list($companies_pkey, $users_pkey);

    return $hashes;
}

1;