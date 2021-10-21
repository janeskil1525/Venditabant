package venditabant::Helpers::Warehouses::Warehouse;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;
use venditabant::Model::Warehouses;

has 'pg';


async sub upsert ($self, $companies_pkey, $users_pkey, $warehouse ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $customers_pkey = venditabant::Model::Warehouses->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $warehouse
        );
        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Sentinel::Sentinelsender', 'upsert', $err
    ) if $err;

    return $err ? $err : 'success';
}

async sub load_list ($self, $companies_pkey, $users_pkey) {

    my $result;
    my $err;
    eval {
        $result = venditabant::Model::Warehouses->new(
            db => $self->pg->db
        )->load_list_p (
            $companies_pkey, $users_pkey
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Warehouses::Warehouse', 'load_list', $err
    ) if $err;

    return $result;
}

1;