package Database::Model::Postgres;
use Mojo::Base -base, -signatures, -async_await;

use List::MoreUtils qw{first_index};

has 'pg';
has 'log';


sub list($self, $data, $table) {

    my $fields = $table->{table}->{list}->{select_fields};
    my $mey_exists = 0;
    $mey_exists = scalar @{ $table->{keys}->{fk} } if $table->{keys}->{fk};
    #$mey_exists = 0 unless $mey_exists;

    my $condition = {};
    if ($mey_exists > 0) {
        ## make key logic
    };

    my $result = $self->pg->db->select(
        $table->{table_name},
        [$fields],
        $condition
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}

sub test_list($self, $data, $table, $method) {

    my $key_exists = exists $data->{keys};
    #$mey_exists = 0 unless $mey_exists;

    my $condition = {};
    if ($key_exists > 0) {
        $condition = $data->{keys};
    };
    $condition = $self->build_condition($condition, $data, $table->{column_names});
    my $result = $self->pg->db->select(
        $table->{table_name},
        [$method->{select_fields}],
        $condition
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}

sub build_condition($self, $condition, $data, $column_names) {

    my $index = first_index {'companies_fkey' eq $_->{column_name}} @{$column_names};
    if ($index > -1) {
        $condition->{companies_fkey} = $data->{companies_fkey};
    }

    $index = first_index {'users_fkey' eq $_->{column_name}} @{$column_names};
    if ($index > -1) {
        $condition->{users_fkey} = $data->{users_fkey};
    }

    return $condition;
}
1;