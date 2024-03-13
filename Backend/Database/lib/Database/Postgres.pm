package Database::Postgres;
use Mojo::Base -base, -signatures, -async_await;

use Database::Helper::Instring;
use Scalar::Util qw {reftype};

has 'pg';
has 'log';

sub get_tables($self, $excluded, $schema) {
    $schema = 'public' unless $schema;

    my @methods = ();
    my @tables = $self->_get_tables($excluded, $schema);
    my $length = scalar @tables;
    for (my $i = 0; $i < $length; $i++) {
        my $table = $tables[$i];
        my $column_names = $self->get_table_column_names($table->{table_name}, $schema);
        my $specials = $self->get_specials_data($table->{table_name}, $schema);
        my $method = $self->build_methods($table, $specials, $column_names);
        push (@methods, $method);
        my $temp = 1;
    }
    my $meth = \@methods;

    return $meth;
}

sub build_methods($self, $table, $specials, $column_names) {

    my $methods->{table_name} = $table->{table_name};
    $methods->{keys} = $self->_get_keys($specials, $column_names);
    my $method = $self->build_create($methods->{keys}->{pk}, $specials, $column_names);
    push @{$methods->{methods}}, $method ;
    $method = $self->build_update($methods->{keys}->{pk}, $specials, $column_names);
    push @{$methods->{methods}}, $method ;
    $method = $self->build_delete($specials, $column_names);
    push @{$methods->{methods}}, $method ;
    $method = $self->build_load($methods->{keys}->{pk}, $specials, $column_names);
    push @{$methods->{methods}}, $method ;

    my $length = scalar @{$specials};
    if ($length > 0) {
        for (my $i = 0; $i < $length; $i++) {
            $method = $self->build_list(@{$specials}[$i], $column_names);
            push @{$methods->{methods}}, $method ;
        }

    } else {
        $method = $self->build_list('', $column_names);
        push @{$methods->{methods}}, $method ;
    }


    return $methods;
}

sub build_load($self, $primary_key, $specials, $column_names) {
    my $method->{method} = 'get';

    $method->{primary_key} = $primary_key;
    $method->{action} = 'load';
    $method->{controller} = 'pgload';

    my $length = scalar @{$column_names};
    for (my $i = 0; $i < $length; $i++) {
        if ($i ==0) {
            $method->{load_fields} = @{$column_names}[$i]->{column_name};
        } else {
            $method->{load_fields} .= ", " . @{$column_names}[$i]->{column_name};
        }
    }
    return $method;
}

sub build_create($self, $primary_key, $specials, $column_names) {
    my $method->{method} = 'post';

    unless ($primary_key) {
        my $test = 1;
    }
    $method->{action} = 'create';
    $method->{controller} = 'pgcreate';
    $method->{create_fields} = {};
    my $nocreate = "editnum insby insdatetime modby moddatetime $primary_key" ;
    my $length = scalar @{$column_names};
    for (my $i = 0; $i < $length; $i++) {
        if (length(@{$column_names}[$i]->{column_name})) {
            if (index($nocreate, @{$column_names}[$i]->{column_name}) == -1) {
                $method->{create_fields}->{@{$column_names}[$i]->{column_name}} = @{$column_names}[$i]->{column_name};
            }
        }
    }
    return $method;
}

sub build_update($self, $primary_key, $specials, $column_names) {
    my $method->{method} = 'put';

    $method->{action} = 'update';
    $method->{controller} = 'pgupdate';
    $method->{update_fields} = {};
    my $nocreate = "insby insdatetime $primary_key" ;
    my $length = scalar @{$column_names};
    for (my $i = 0; $i < $length; $i++ ) {
        if (length(@{$column_names}[$i]->{column_name})) {
            if (index($nocreate, @{$column_names}[$i]->{column_name}) == -1) {
                $method->{update_fields}->{@{$column_names}[$i]->{column_name}} = @{$column_names}[$i]->{column_name};
            }
        }
    }
    return $method;
}

sub build_list($self, $specials, $column_names) {

    my $method->{method} = 'get';

    $method->{action} = 'list';
    $method->{controller} = 'pglist';
    $method->{select_fields} = '';
    my $length = scalar @{$column_names};
    for (my $i = 0; $i < $length; $i++) {
        if (length(@{$column_names}[$i]->{column_name}) > 0) {
            if ($i == 0) {
                $method->{select_fields} = @{$column_names}[$i]->{column_name};
            } else {
                $method->{select_fields} = $method->{select_fields} . ", " . @{$column_names}[$i]->{column_name};
            }
        }
    }
    return $method;
}

sub build_delete($self, $specials, $column_names) {
    my $method->{method} = 'delete';
    $method->{action} = 'delete';
    $method->{controller} = 'pgdelete';

    return $method;
}

sub _get_keys($self, $specials, $column_names) {

    my $keys->{has_companies} = 0;
    $keys->{has_users} = 0;
    $keys->{fk} = ();
    my $length = scalar @{$column_names};
    for (my $i = 0; $i < $length; $i++ ) {
        if (length(@{$column_names}[$i]->{column_name}) > 0) {
            if (index(@{$column_names}[$i]->{column_name},'_pkey') > -1){
                $keys->{pk} = @{$column_names}[$i]->{column_name};
            } elsif (@{$column_names}[$i]->{column_name} eq 'companies_fkey') {
                $keys->{has_companies} = 1;
            } elsif (@{$column_names}[$i]->{column_name} eq 'users_fkey') {
                $keys->{has_users} = 1;
            } elsif (index(@{$column_names}[$i]->{column_name},'_fkey') > -1) {
                push @{$keys->{fk}}, @{$column_names}[$i]->{column_name};
            }
        }
    }
    return $keys;
}

sub _get_tables($self, $excluded, $schema) {

    my $tables_stmt = qq {
        SELECT table_name FROM
            information_schema.columns WHERE
                table_schema = ? AND table_name
        NOT IN (SELECT table_name FROM database_excludes) GROUP BY table_name
    };

    my @tables = $self->pg->db->query($tables_stmt,($schema))->hashes;
    @tables = @{ $tables[0] };

    return @tables;

}

sub get_specials_data($self, $table, $schema) {

    $schema = 'public' unless $schema;
    my $specials = $self->pg->db->query(
        qq{
            SELECT method, select_fields, fkey
                FROM database_specials
            WHERE table_schema = ?
                AND table_name = ?
        }, ($schema, $table)
    )->hashes;

    return $specials;
}

sub get_table_column_names($self, $table, $schema) {

    $schema = 'public' unless $schema;
    my @column_names = $self->pg->db->query(
        qq{
            SELECT column_name
                FROM information_schema.columns
            WHERE table_schema = ?
                AND table_name = ?
        }, ($schema, $table)
    )->hashes;

    @column_names = @{ $column_names[0] } if @{ $column_names[0] };
    return \@column_names;
}

1;