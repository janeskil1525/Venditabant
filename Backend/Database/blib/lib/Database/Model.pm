package Database::Model;
use Mojo::Base -base, -signatures, -async_await;

use List::MoreUtils qw{first_index};
use Database::Model::Postgres

has 'pg';
has 'log';


async sub list_p($self, $data, $table) {

    my $method = $table->{methods};
    my $index = first_index { 'list' eq $_->{action}} @{$method};

    my $list = Database::Model::Postgres->new(
         pg => $self->pg, log => $self->log
    )->test_list($data, $table, @{$method}[$index]);

    return $list;
}

1;