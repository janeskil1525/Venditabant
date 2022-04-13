package Release;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Release::Helpers::Release;

our $VERSION = '0.04';

has 'pg';

async sub release ($self) {
    return Release::Helpers::Release->new(
        pg => $self->pg
    )->release();
}
1;