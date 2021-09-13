package venditabant::Helpers::Pricelists;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Pricelists;

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
1;