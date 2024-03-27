package Database::Model;
use Mojo::Base -base, -signatures, -async_await;

use Database::Model::Postgres

has 'pg';
has 'log';


async sub list_p($self, $data, $table, $key_value) {

    my $hash = Database::Model::Postgres->new(
        pg => $self-pg, log => $self->log
    )->list($data, $table, $key_value);

    return $hash
}

1;