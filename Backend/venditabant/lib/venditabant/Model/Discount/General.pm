package venditabant::Model::Discount::General;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub upsert($self, $companies_pkey, $users_pkey, $data) {

    my $stmt = qq {
        INSERT INTO customer_discount (insby, modby, customers_fkey, minimumsum, discount)
        VALUES ((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?)
        RETURNING customer_discount_pkey;
    };

    my $customer_discount_pkey = $self->db->query(
        $stmt,
        (
            $users_pkey,
            $users_pkey,
            $data->{customers_fkey},
            $data->{minimumsum},
            $data->{discount},
        )
    )->hash->{customer_discount_pkey};

    return $customer_discount_pkey;
}

async sub load_list($self, $companies_pkey, $users_pkey, $customers_fkey){

    my $stmt = qq{
        SELECT customer_discount_pkey, customers_fkey, discount, minimumsum
        FROM customer_discount
        WHERE customers_fkey = ?
    };

    my $result = $self->db->query(
        $stmt,
        ($customers_fkey)
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}

async sub delete($self, $companies_pkey, $users_pkey, $customer_discount_pkey) {

    $self->db->delete(
        'customer_discount',
            {
                customer_discount_pkey => $customer_discount_pkey
            }
    );
}
1;