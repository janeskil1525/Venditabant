package venditabant::Model::Sentinel;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'pg';

sub insert ($self, $data) {

    $self->pg->db->insert (
        'sentinel',
            {
                $data
            }
    );
}
1;