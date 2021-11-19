package venditabant::Model::Discount::Stockitem;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub upsert($self, $companies_pkey, $users_pkey, $data) {

    my $stmt = qq {
        INSERT INTO stockitem_customer_discount (insby, modby, customers_fkey, stockitems_fkey, discount)
        VALUES ((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?)
        ON CONFLICT (customers_fkey, stockitems_fkey)
        DO UPDATE moddatetime = now(),
                modby = (SELECT userid FROM users WHERE users_pkey = ?),
                discount = ?
        RETURNING stockitem_customer_discount_pkey;
    };

    my $stockitem_customer_discount_pkey = $self->db->query(
        $stmt,
            (
                $users_pkey,
                $users_pkey,
                $data->{customers_fkey},
                $data->{stockitems_fkey},
                $data->{discount},
                $users_pkey,
                $data->{discount},
            )
    )->{stockitem_customer_discount_pkey};

    return $stockitem_customer_discount_pkey;
}

async sub load_list($self, $companies_pkey, $users_pkey, $customers_fkey){

    my $stmt = qq{
        SELECT stockitems_fkey, discount, stockitem, description
        FROM stockitems JOIN stockitem_customer_discount
        ON stockitems_fkey = stockitems_pkey
        WHERE customers_fkey = ? AND companies_fkey = ?
    };

    my $result = $self->db->query(
        $stmt,
            ($customers_fkey, $companies_pkey)
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}
1;