package venditabant::Helpers::Users;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Users;
use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $user) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $user_obj = venditabant::Model::Users->new(db => $db);
        my $stockitems_pkey = $user_obj->upsert(
            $user
        );

        my $users_companies_pkey = $user_obj->upsert_user_companies(
            $companies_pkey, $stockitems_pkey
        );

        $tx->commit();
    };

    $err = $@ if $@;
    say "error '$err'" if $err;

    return $err ? $err : 'success';
}

async sub load_list ($self, $companies_pkey) {

    say Dumper($companies_pkey);

    my $result = venditabant::Model::Users->new(
        db => $self->pg->db
    )->load_list($companies_pkey);

    return $result;
}
1;