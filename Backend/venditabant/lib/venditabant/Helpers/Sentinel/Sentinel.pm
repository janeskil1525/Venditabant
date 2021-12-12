package venditabant::Helpers::Sentinel::Sentinel;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Sentinel::Sentinel;

use Data::Dumper;

has 'pg';

async sub load_list ($self) {

    my $hashes = venditabant::Model::Sentinel::Sentinel->new(db => $self->pg->db)->load_list();

    return $hashes;
}
1;