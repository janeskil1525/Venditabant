package venditabant::Helpers::Mailer::Templates::Mailtemplates;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;


use venditabant::Model::Mailtemplates;

use Data::Dumper;

has 'pg';

async sub load_list ($self) {

    my $hashes = venditabant::Model::Mailtemplates->new(db => $self->pg->db)->load_list();

    return $hashes;
}
1;