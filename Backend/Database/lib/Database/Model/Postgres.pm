package Database::Model::Postgres;
use Mojo::Base -base, -signatures, -async_await;

has 'pg';
has 'log';
has 'table';


sub load_list($self) {

    #my $result = $self->pg->db->select();

    my $hash;
    #$hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}
1;