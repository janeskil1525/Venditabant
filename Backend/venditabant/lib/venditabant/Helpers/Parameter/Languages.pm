package venditabant::Helpers::Parameter::Languages;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Languages;
use Data::Dumper;

has 'pg';

async sub load_list ($self) {

        my $languages = await venditabant::Model::Lan::Languages->new(
            db => $self->pg->db
        )->load_list_p();


    return $languages;
}

1;