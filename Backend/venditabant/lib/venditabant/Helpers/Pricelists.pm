package venditabant::Helpers::Pricelists;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Pricelists;
use venditabant::Model::PricelistItems;

has 'pg';

async sub load_list_heads ($self, $companies_pkey) {


    my $result = await venditabant::Model::Pricelists->new(
        db => $self->pg->db
    )->load_list_heads_p(
        $companies_pkey
    );

    return $result;
}

async sub upsert_head ($self, $companies_pkey, $pricelist) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        say "upsert ";
        my $pricelists_pkey = venditabant::Model::Pricelists->new(
            db => $db
        )->upsert(
            $companies_pkey, $pricelist
        );
        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;

    return $err ? $err : 'success';
}

async sub load_list_items ($self, $companies_pkey, $pricelist) {

    my $result = await venditabant::Model::PricelistItems->new(
        db => $self->pg->db
    )->load_list_items_p(
        $companies_pkey, $pricelist
    );

    return $result;
}

async sub insert_item ($self, $companies_pkey, $pricelist_item) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        say "upsert ";
        my $pricelists_pkey = venditabant::Model::PricelistItems->new(
            db => $db
        )->insert_item(
            $companies_pkey, $pricelist_item
        );
        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;

    return $err ? $err : 'success';
}
1;