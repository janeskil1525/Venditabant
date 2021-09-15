package venditabant::Helpers::Customers;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Customers;
use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $customers ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();
say "upsert $companies_pkey " . Dumper($customers);
    my $err;
    eval {
        my $customers_pkey = venditabant::Model::Customers->new(
            db => $db
        )->upsert(
            $companies_pkey, $customers
        );
        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;

    return $err ? $err : 'success';
}

async sub load_list ($self, $companies_pkey) {

    my $load_stmt = qq {
        SELECT customers_pkey, customer, name, registrationnumber, homepage, phone,
            (SELECT pricelist FROM pricelists WHERE pricelists_pkey = pricelists_fkey) as pricelist
            FROM customers
        WHERE companies_fkey = ?
    };

    my $list = $self->pg->db->query($load_stmt,($companies_pkey));

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}

1;