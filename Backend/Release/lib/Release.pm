package Release;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Release::Helpers::Release;

our $VERSION = '0.10';

has 'pg';

async sub release ($self) {
    return Release::Helpers::Release->new(
        pg => $self->pg
    )->release();
}

async sub release_single_company($self, $companies_pkey) {
    return Release::Helpers::Release->new(
        pg => $self->pg,
        db => $self->pg->db,
    )->release_single_company($companies_pkey);
}
1;