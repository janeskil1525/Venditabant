package Database::Postgres;
use Mojo::Base -base, -signatures, -async_await;

has 'pg';
has 'log';

sub get_tables($self, $excluded, $schema) {
    $schema = 'public' unless $schema;

    my @methods = ();
    my @tables = $self->_get_tables($excluded, $schema);
    @tables = @{ $tables[0] };
    my $length = scalar @tables;
    for (my $i = 0; $i < $length; $i++) {
        my $table = $tables[$i];
        my @column_names = $self->get_table_column_names($table->{table_name}, $schema);
        @column_names = @{ $column_names[0] };
        my $method = $self->build_methods($table, @column_names);
        push (@methods, $method);
        my $temp = 1;
    }
    my $meth = \@methods;

    return $meth;
}

sub build_methods($self, $table, @column_names) {

    my $methods->{table_name} = $table->{table_name};
    $methods->{keys} = $self->_get_keys(@column_names);
    $methods->{table}->{create} = $self->build_create($methods->{keys}->{pk}, @column_names);
    $methods->{table}->{update} = $self->build_update($methods->{keys}->{pk}, @column_names);
    $methods->{table}->{list} = $self->build_list(@column_names);
    $methods->{table}->{delete} = $self->build_delete(@column_names);

    return $methods;
}

sub build_create($self, $primary_key, @column_names) {
    my $method->{method} = 'post';

    $method->{controller} = 'pgcreate';
    $method->{create_fields} = {};
    my $nocreate = "editnum insby insdatetime modby moddatetime $primary_key" ;
    my $length = scalar @column_names;
    for (my $i = 0; $i < $length; $i++) {
        if (length($column_names[$i]->{column_name})) {
            if (index($nocreate, $column_names[$i]->{column_name}) == -1) {
                $method->{create_fields}->{$column_names[$i]->{column_name}} = $column_names[$i]->{column_name};
            }
        }
    }
    return $method;
}

sub build_update($self, $primary_key, @column_names) {
    my $method->{method} = 'put';

    $method->{controller} = 'pgupdate';
    $method->{update_fields} = {};
    my $nocreate = "insby insdatetime $primary_key" ;
    my $length = scalar @column_names;
    for (my $i = 0; $i < $length; $i++ ) {
        if (length($column_names[$i]->{column_name})) {
            if (index($nocreate, $column_names[$i]->{column_name}) == -1) {
                $method->{update_fields}->{$column_names[$i]->{column_name}} = $column_names[$i]->{column_name};
            }
        }
    }
    return $method;
}

sub build_list($self, @column_names) {

    my $method->{method} = 'get';
    $method->{controller} = 'pglist';
    $method->{select_fields} = '';
    my $length = scalar @column_names;
    for (my $i = 0; $i < $length; $i++) {
        if (length($column_names[$i]->{column_name}) > 0) {
            if ($i == 0) {
                $method->{select_fields} = $column_names[$i]->{column_name};
            } else {
                $method->{select_fields} = $method->{select_fields} . ", " . $column_names[$i]->{column_name};
            }
        }
    }
    return $method;
}

sub build_delete($self, @column_names) {
    my $method->{method} = 'delete';
    $method->{controller} = 'pgdelete';

    return $method;
}

sub _get_keys($self, @column_names) {

    my $keys->{has_companies} = 0;
    $keys->{has_users} = 0;
    $keys->{fk} = ();
    my $length = scalar @column_names;
    for (my $i = 0; $i < $length; $i++ ) {
        if (length($column_names[$i]->{column_name}) > 0) {
            if (index($column_names[$i]->{column_name},'_pkey') > -1){
                $keys->{pk} = $column_names[$i]->{column_name};
            } elsif ($column_names[$i]->{column_name} eq 'companies_fkey') {
                $keys->{has_companies} = 1;
            } elsif ($column_names[$i]->{column_name} eq 'users_fkey') {
                $keys->{has_users} = 1;
            } elsif (index($column_names[$i]->{column_name},'_fkey') > -1) {
                push @{$keys->{fk}}, $column_names[$i]->{column_name};
            }
        }
    }
    return $keys;
}

sub _get_tables($self, $excluded, $schema) {

    $excluded = 'mojo_migrations' unless $excluded;
    my $tables = qq {
        SELECT table_name FROM
            information_schema.columns WHERE
                table_schema = ? AND table_name NOT IN (?) GROUP BY table_name
    };

    return $self->pg->db->query($tables,($schema, $excluded))->hashes->to_array;;
}
sub _build_excluded_tables($self, $excluded) {
    my $result;
    $result = 'mojo_migrations' unless $excluded;


    return $result;
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