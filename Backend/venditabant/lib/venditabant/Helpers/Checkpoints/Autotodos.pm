package venditabant::Helpers::Checkpoints::Autotodos;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::AutoTodo;
use Data::Dumper;

has 'pg';

async sub load_list ($self, $companies_pkey, $users_pkey) {
    return await venditabant::Model::AutoTodo->new(
        db => $self->pg->db
    )->load_list_p(
        $companies_pkey
    );
}
1;