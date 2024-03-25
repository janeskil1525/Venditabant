package Database::Model::Postgres;
use Mojo::Base -base, -signatures, -async_await;

has 'pg';
has 'log';



async sub list($self, $data, $table, $key_value) {

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
1;