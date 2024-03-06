package Database;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

our $VERSION = '0.01';

use Database::Postgres;
use Database::Model::Postgres;

has 'pg';
has 'log';
has 'dist_dir';

sub get_tables($self) {

    $self->pg->migrations->name('database')->from_file(
        $self->dist_dir->child('migrations/database.sql')
    )->migrate(0);

    my $excluded = Database::Model::Postgres->new(
        pg => $self->pg, log => $self->log
    )->load_list();

    my $tables = Database::Postgres->new($self->pg, $self->log)->get_tables($excluded,'public');
    return $tables;
}
1;