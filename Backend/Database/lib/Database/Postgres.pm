package Database::Postgres;
use Mojo::Base -base, -signatures, -async_await;

use Database::Helper::Instring;
use Scalar::Util qw {reftype};
use Syntax::Operator::Matches qw( matches mismatches );

has 'pg';
has 'log';

sub get_tables($self, $excluded, $schema) {
    $schema = 'public' unless $schema;

    my @methods = ();
    my @tables = $self->_get_tables($schema);
    my $excluded_tables = $self->_get_excluded_tables();
    my $length = scalar @tables;
    for (my $i = 0; $i < $length; $i++) {
        my $table = $tables[$i];
        my $column_names = $self->get_table_column_names($table->{table_name}, $schema);
        my $specials = $self->get_specials_data($table->{table_name}, $schema);
        my $method = $self->build_methods($table, $specials, $column_names, $excluded_tables);
        $method->{column_names} = $column_names;
        push (@methods, $method);
        my $temp = 1;
    }

    my @views = $self->_get_views($schema);
    $length = scalar @views;
    for (my $i = 0; $i < $length; $i++ ) {
        my $view = $views[$i];
        my $column_names = $self->get_table_column_names($view->{table_name}, $schema);
        my $method = $self->build_view_methods($view, $column_names);
        $method->{column_names} = $column_names;
        push (@methods, $method);
    }
    my $meth = \@methods;

    return $meth;
}

sub build_view_methods($self, $view, $column_names) {

    my $methods->{table_name} = $view->{table_name};
    $methods->{keys} = $self->_get_keys($column_names);
    $methods->{create_endpoint} = 1;
    my $method = $self->get_view_list($view->{table_name},$column_names);
    push @{$methods->{methods}}, $method ;

    return $methods;
}

sub build_methods($self, $table, $specials, $column_names, $excluded_tables) {

    my $methods->{table_name} = $table->{table_name};
    $methods->{keys} = $self->_get_keys($column_names);
    $methods->{create_endpoint} = $self->_create_endpoint($table->{table_name}, $excluded_tables);
    if ($methods->{create_endpoint} > 0) {
        my $method = $self->build_create($methods->{keys}->{pk}, $specials, $column_names);
        push @{$methods->{methods}}, $method ;
        $method = $self->build_update($methods->{keys}->{pk}, $specials, $column_names);
        push @{$methods->{methods}}, $method ;
        $method = $self->build_delete($methods->{keys}->{pk},$specials, $column_names);
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
    }


    return $methods;
}

sub build_load($self, $primary_key, $specials, $column_names) {
    my $method->{method} = 'get';

    $method->{type} = 'table';
    my $special_method = -1;
    if (scalar @{$specials} > 0) {
        $special_method = $self->_exists_in_specials($specials, 'load');
    }
    if ($special_method == -1) {
        $method->{primary_key} = $primary_key;
        $method->{action} = 'load';
        $method->{controller} = 'pgload';

        my $length = scalar @{$column_names};
        for (my $i = 0; $i < $length; $i++) {
            if ($i == 0) {
                $method->{select_fields} = @{$column_names}[$i]->{column_name};
            }
            else {
                $method->{select_fields} .= ", " . @{$column_names}[$i]->{column_name};
            }
        }
    } else {
        my $special = @{$specials}[$special_method];
        $method->{select_fields} = $special->{select_fields};
        $method->{primary_key} = $special->{pk} if $special->{pk};
        $method->{primary_key} = $primary_key unless $method->{primary_key};
        $method->{action} = $special->{'method_pseudo_name'} if $special->{'method_pseudo_name'};
        $method->{action} = $special->{method} unless $method->{action};
        $method->{controller} = 'pgload';
    }
    return $method;
}

sub build_create($self, $primary_key, $specials, $column_names) {

    unless ($primary_key) {
        my $temp = 1;
    }
    my $method->{method} = 'post';
    $method->{action} = 'create';
    $method->{controller} = 'pgcreate';
    $method->{create_fields} = {};
    $method->{type} = 'table';
    my $nocreate = "editnum insby insdatetime modby moddatetime $primary_key";
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
    $method->{type} = 'table';

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

sub get_view_list($self, $view_name, $column_names) {
    my $method->{method} = 'get';

    $method->{select_fields} = ();
    $method->{action} = 'list';
    $method->{controller} = 'pglist';
    $method->{type} = 'view';

    my $length = scalar @{$column_names};
    #$method->{select_fields} = \@{$column_names};
    for (my $i = 0; $i < $length; $i++) {
        if (length(@{$column_names}[$i]->{column_name}) > 0) {
            push(@{$method->{select_fields}}, @{$column_names}[$i]->{column_name});
        }
    }

    for (my $i = 0; $i < $length; $i++) {
        if (index($view_name, @{$column_names}[$i]->{column_name}) > -1) {
            $method->{foreign_key} = @{$column_names}[$i]->{column_name};
        }
    }

    return $method;
}

sub build_list($self, $specials, $column_names) {
    my $method->{method} = 'get';

    $method->{type} = 'table';
    $method->{select_fields} = ();
    if ( $specials and reftype $specials eq reftype {}) {
        $method->{action} = $specials->{method_pseudo_name} if $specials->{method_pseudo_name};
        $method->{select_fields} = $specials->{select_fields} if $specials->{select_fields};
        $method->{foreign_key} = $specials->{fk} if $specials->{fk};
    }
    $method->{action} = 'list' unless $method->{action};
    $method->{controller} = 'pglist';

    unless ($method->{select_fields}) {
        my $length = scalar @{$column_names};
        for (my $i = 0; $i < $length; $i++) {
            if (length(@{$column_names}[$i]->{column_name}) > 0) {
                push(@{$method->{select_fields}}, @{$column_names}[$i]->{column_name});
            }
        }
    }

    return $method;
}

sub build_delete($self, $primary_key, $specials, $column_names) {
    my $method->{method} = 'delete';
    $method->{type} = 'table';

    my $special_method = -1;
    if (scalar @{$specials} > 0) {
        $special_method = $self->_exists_in_specials($specials, 'delete');
    }
    if ($special_method == -1) {
        $method->{action} = 'delete';
        $method->{controller} = 'pgdelete';
        $method->{primary_key} = $primary_key;
    } else {
        my $special = @{$specials}[$special_method];
        my $test = 1;
    }

    return $method;
}

sub _create_endpoint($self, $table, $excluded_tables) {
    my $result = 1;
    my $length = scalar @{$excluded_tables};
    for (my $i = 0; $i < $length; $i++) {
        if ($table eq @{$excluded_tables}[$i]->{table_name}) {
            $result = 0;
        }
    }
    return $result;
}

sub _get_keys($self, $column_names) {

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

sub _get_tables($self, $schema) {

    my $tables_stmt = qq {
        SELECT table_name
          FROM information_schema.tables
         WHERE table_schema = ?
           AND table_type='BASE TABLE';
    };

    my @tables = $self->pg->db->query($tables_stmt,($schema))->hashes;
    @tables = @{ $tables[0] };

    return @tables;
}

sub _get_excluded_tables($self) {

    my $tables_stmt = qq {
        SELECT table_name FROM database_excludes
    };

    my @tables = $self->pg->db->query($tables_stmt)->hashes;
    @tables = @{ $tables[0] };
    my $tables = \@tables;
    return $tables;
}

sub _get_views($self, $schema) {
    my $views_stmt = qq {
        SELECT table_name
            FROM
              information_schema.views
            WHERE
              table_schema NOT IN (
                'information_schema', 'pg_catalog'
              ) AND table_schema = ?
            ORDER BY table_name;
    };

    my @views = $self->pg->db->query($views_stmt,($schema))->hashes;
    @views =  @{$views[0]};

    return @views;
}

sub get_specials_data($self, $table, $schema) {

    $schema = 'public' unless $schema;
    my $specials = $self->pg->db->query(
        qq{
            SELECT method, select_fields, fkey, pkey, method_pseudo_name
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

sub _exists_in_specials($self, $specials, $method) {

    my $special = -1;
    my $length = scalar @{$specials};

    for (my $i = 0; $i < $length; $i++) {
        if (@{$specials}[$i]->{method} eq $method) {
            $special = $i;
        }
    }

    return $special;
}
1;