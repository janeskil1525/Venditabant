package venditabant::Helpers::Stockitems;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Stockitems;

use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $stockitem) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $stockitems_pkey = venditabant::Model::Users->new(
            db => $db
        )->upsert(
            $companies_pkey, $stockitem
        );
        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;

    return $err ? $err : 'success';
}

async sub load_list ($self, $companies_pkey) {

    my $load_stmt = qq {
        SELECT stockitems_pkey, stockitem, description
            FROM stockitems
        WHERE companies_fkey = ?
    };

    my $list = $self->pg->db->query($load_stmt,($companies_pkey));

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}
1;