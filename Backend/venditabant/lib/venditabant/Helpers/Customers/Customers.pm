package venditabant::Helpers::Customers::Customers;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Customer::Customers;
use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $users_pkey, $customers ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $customers_pkey = venditabant::Model::Customer::Customers->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $customers
        );
        $tx->commit();
    };
    $err = $@ if $@;
       $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Customers::Customers', 'upsert', $err
    ) if $err;

    return $err ? $err : 'success';
}

async sub load_list ($self, $companies_pkey) {

    my $load_stmt = qq {
        SELECT customers_pkey, customer, name, registrationnumber, homepage, phone,
            (SELECT pricelist FROM pricelists WHERE pricelists_pkey = pricelists_fkey) as pricelist,
            comment, languages_fkey
            FROM customers
        WHERE companies_fkey = ?
    };

    my $list = $self->pg->db->query($load_stmt,($companies_pkey));

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}

1;