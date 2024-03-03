package Database::Postgres;
use Mojo::Base -base, -signatures, -async_await;

has 'pg';

sub get_tables($self, $excluded, $schema) {
    $schema = 'public' unless $schema;

    my @methods = ();
    my @tables = $self->_get_tables($excluded, $schema);
    for my $i (0 .. $tables[0]) {
        my $table = $tables[0][$i];
        my $column_names = $self->get_table_column_names($table->{table_name}, $schema);
        my $methods = $self->build_methods($table, $column_names);
        push (@methods, $methods);
        my $temp = 1;
    }

    return @methods;
}

sub build_methods($self, $table, $column_names) {

    my $methods->{table} = $table;
    $methods->{table}->{create} = $self->build_create($column_names);
    $methods->{table}->{update} = $self->build_update($column_names);
    $methods->{table}->{list} = $self->build_list($column_names);
    $methods->{table}->{delete} = $self->build_delete($column_names);

    return $methods;
}

sub build_create($self, $column_names) {
    my $method->{method} = 'post';

}

sub build_update($self, $column_names) {
    my $method->{method} = 'post';
}

sub build_list($self, $column_names) {
    my $method->{method} = 'get';

    $method->{select_fields} = '';
    for my $i (0 .. $column_names) {
        if ($i == 0) {
            $method->{select_fields} = "( " . $columnames[$i]->{column_name};
        } else {
            $method->{select_fields} = $method->{select_fields} . ", " . $columnames[$i]->{column_name};
        }
        if (index($columnames[$i]->{column_name}, "_fkey")) {

        }
    }
    $method->{select_fields} = $method->{select_fields} . " )";

}

sub build_delete($self, $column_names) {
    my $method->{method} = 'put';
}

sub _get_tables($self, $excluded, $schema) {
    my $tables = qq {
        SELECT table_name FROM
            information_schema.columns WHERE
                table_schema = ? AND table_name NOT IN (?) GROUP BY table_name
    };

    return $self->pg->db->query($tables,($schema, $excluded))->hashes->to_array;;
}

sub get_table_column_names($self, $table, $schema) {

    $schema = 'public' unless $schema;
    my $fields = $self->pg->db->query(
        qq{
            SELECT column_name
                FROM information_schema.columns
            WHERE table_schema = ?
                AND table_name = ?
        }, ($schema, $table)
    )->hashes;

    return $fields;
}

1;