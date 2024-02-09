package Companies::Helpers::Users;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Companies::Model::Users;
use Data::Dumper;

has 'pg';

async sub upsert_p ($self, $companies_pkey, $user) {
    return $self->upsert($companies_pkey, $user);
}

sub insert ($self, $companies_pkey, $user) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $user_obj = Companies::Model::Users->new(db => $db);
        my $users_pkey = $user_obj->insert(
            $user
        );

        my $users_companies_pkey = $user_obj->upsert_user_companies(
            $companies_pkey, $users_pkey
        );

        $tx->commit();
    };

    $err = $@ if $@;
    $self->capture_message (
        $self->pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;

    return $err ? $err : 'success';
}

async sub load_list ($self, $companies_pkey) {

    my $result = Companies::Model::Users->new(
        db => $self->pg->db
    )->load_list($companies_pkey);

    return $result;
}

async sub load_list_support ($self) {

    my $result = Companies::Model::Users->new(
        db => $self->pg->db
    )->load_list_support();

    return $result;
}
1;