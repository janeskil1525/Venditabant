package CheckPoints::Helpers::Autotodos;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use CheckPoints::Model::AutoTodo;
use Data::Dumper;

has 'pg';

async sub load_list ($self, $companies_pkey, $users_pkey) {
    return await CheckPoints::Model::AutoTodo->new(
        db => $self->pg->db
    )->load_list_p(
        $companies_pkey
    );
}
1;