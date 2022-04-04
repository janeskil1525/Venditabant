package Customers::Model::Stockitem;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub upsert_p($self, $companies_pkey, $users_pkey, $data) {
    return $self->upsert($companies_pkey, $users_pkey, $data);
}

sub upsert($self, $companies_pkey, $users_pkey, $data) {

    my $stmt = qq {
        INSERT INTO stockitem_customer_discount (insby, modby, customers_fkey, stockitems_fkey, discount)
        VALUES ((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?)
        ON CONFLICT (customers_fkey, stockitems_fkey)
        DO UPDATE SET moddatetime = now(),
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
    )->hash->{stockitem_customer_discount_pkey};

    return $stockitem_customer_discount_pkey;
}

async sub load_list_p($self, $companies_pkey, $users_pkey, $customers_fkey){
    return $self->load_list($companies_pkey, $users_pkey, $customers_fkey);
}

sub load_list($self, $companies_pkey, $users_pkey, $customers_fkey){

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

async sub load_discount_p($self, $companies_pkey, $users_pkey, $customers_fkey, $stockitems_fkey) {

    my $result = $self->load_discount($companies_pkey, $users_pkey, $customers_fkey, $stockitems_fkey);

    return $result;
}

sub load_discount($self, $companies_pkey, $users_pkey, $customers_fkey, $stockitems_fkey) {

    my $result = $self->db->select(
        'stockitem_customer_discount',
        ['discount'],
        {
            customers_fkey => $customers_fkey,
            stockitems_fkey => $stockitems_fkey
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows();

    if(!exists $hash->{discount}) {
        $hash->{discount} = '';
    }

    return $hash;
}
1;