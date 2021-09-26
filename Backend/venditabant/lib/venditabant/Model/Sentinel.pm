package venditabant::Model::Sentinel;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'pg';

sub insert ($self, $data) {

    say "insert";

    $self->pg->db->insert (
        'sentinel',
            {
                $data
            }
    );
}
1;