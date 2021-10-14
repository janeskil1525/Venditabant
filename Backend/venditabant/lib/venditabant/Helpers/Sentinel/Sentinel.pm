package venditabant::Helpers::Sentinel::Sentinel;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Sentinel;

use Scalar::Util qw{blessed};
use Data::Dumper;
use Try::Tiny;

has 'pg';

async sub load_list ($self) {

    my $hashes = venditabant::Model::Sentinel->new(db => $self->pg->db)->load_list();

    return $hashes;
}
1;