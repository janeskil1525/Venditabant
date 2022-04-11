package Sentinel::Helpers::Sentinel;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Sentinel::Model::Sentinel;

use Data::Dumper;

has 'pg';

async sub load_list ($self) {

    my $hashes = Sentinel::Model::Sentinel->new(db => $self->pg->db)->load_list();

    return $hashes;
}
1;