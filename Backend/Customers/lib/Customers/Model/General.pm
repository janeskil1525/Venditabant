package Customers::Model::General;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub upsert_p($self, $companies_pkey, $users_pkey, $data) {
    return $self->upsert($companies_pkey, $users_pkey, $data);
}

sub upsert($self, $companies_pkey, $users_pkey, $data) {

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

async sub load_list_p($self, $companies_pkey, $users_pkey, $customers_fkey) {
    return $self->load_list($companies_pkey, $users_pkey, $customers_fkey) ;
}

sub load_list($self, $companies_pkey, $users_pkey, $customers_fkey) {

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

async sub delete_p($self, $companies_pkey, $users_pkey, $customer_discount_pkey) {
    return $self->delete($companies_pkey, $users_pkey, $customer_discount_pkey);
}

sub delete($self, $companies_pkey, $users_pkey, $customer_discount_pkey) {

    $self->db->delete(
        'customer_discount',
            {
                customer_discount_pkey => $customer_discount_pkey
            }
    );
}
1;