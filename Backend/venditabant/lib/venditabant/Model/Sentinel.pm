package venditabant::Model::Sentinel;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

sub load_list ($self) {
    my $result = $self->db->select(
        'sentinel', '*',
            {
            closed => 'false'
        },
            {
                limit => 100, order_by => {-desc => 'sentinel_pkey'}
            }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}

sub insert ($self, $data) {

    $self->db->insert (
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