package Workflows::Model::Workflows;
use Mojo::Base -base, -signatures, -async_await;

has 'db';


async sub load_list ($self, $companies_pkey, $users_pkey) {

    return $self->db->select(
        'workflows',
        ['*']
    )->hashes();
}

1;