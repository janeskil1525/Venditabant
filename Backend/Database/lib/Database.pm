package Database;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

our $VERSION = '0.01';

use Database::Postgres;
use Database::Model::Postgres;

has 'pg';
has 'log';
has 'dist_dir';
has 'tables';

sub get_tables($self) {

    $self->pg->migrations->name('database')->from_file(
        $self->dist_dir->child('migrations/database.sql')
    )->migrate(3);

    my $table->{table_name} = 'database_excludes';
    $table->{keys}->{fk} = ();
    $table->{table}->{list}->{select_fields} = 'table_name';

    my $excluded = Database::Model::Postgres->new(
        pg => $self->pg, log => $self->log
    )->load_list($table,0);

    my $tables = Database::Postgres->new(
        pg => $self->pg, log => $self->log
    )->get_tables($excluded,'public');

    $self->tables($tables);

    return $tables;
}
1;