package Stockitems;
use Mojo::Base -base, -signatures, -async_await;

use Stockitems::Helpers::Stockitems;

our $VERSION = '0.02';

has 'pg';

async sub upsert_p ($self, $companies_pkey, $users_pkey, $stockitem) {
    return Stockitems::Helpers::Stockitems->new(
        pg => $self->pg
    )->upsert_p($companies_pkey, $users_pkey, $stockitem);
}

async sub load_list_p ($self, $companies_pkey) {
    return Stockitems::Helpers::Stockitems->new(
        pg => $self->pg
    )->load_list_p($companies_pkey);
}
1;