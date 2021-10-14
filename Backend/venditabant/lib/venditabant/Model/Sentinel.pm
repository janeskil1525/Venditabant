package venditabant::Model::Sentinel;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'pg';

sub insert ($self, $data) {

    $self->pg->db->insert (
        'sentinel',
            {
                organisation => $data->{organisation},
                source       => $data->{source},
                method       => $data->{method},
                message      => $data->{message},
                recipients   => $data->{recipients}
            }
    );
}
1;