package Sentinel::Model::Log;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

sub load_list ($self) {
    my $result = $self->db->select(
        'sentinel_log', '*',
        {
        },
        {
            limit => 100, order_by => {-desc => 'sentinel_log_pkey'}
        }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}

sub insert ($self, $data) {

    $self->db->insert (
        'sentinel_log',
        {
            source       => $data->{source},
            method       => $data->{method},
            message      => $data->{message},
        }
    );
}

1;