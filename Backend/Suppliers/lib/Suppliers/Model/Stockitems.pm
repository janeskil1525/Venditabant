package Suppliers::Model::Stockitems;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub upsert_supplieritem_p($self, $companies_pkey, $users_pkey, $data) {
    return $self->upsert_supplieritem(
        $companies_pkey, $users_pkey, $data
    );
}

sub upsert_supplieritem($self, $companies_pkey, $users_pkey, $data) {

    my $stmt = qq{
        INSERT INTO supplier_stockitem (
            insby, modby,suppliers_fkey, stockitems_fkey, currencies_fkey, stockitem, description, price
        ) VALUES ((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),
                ?, ?, ? ,? ,? ,?
        ) ON CONFLICT (suppliers_fkey, stockitems_fkey)
            DO UPDATE SET moddatetime = now(),
            modby = (SELECT userid FROM users WHERE users_pkey = ?),
        currencies_fkey = ?, stockitem = ?, description = ?, price = ?
        RETURNING supplier_stockitem_pkey
    } ;

    my $supplier_stockitem_pkey;
    eval {
        $supplier_stockitem_pkey = $self->db->query(
            $stmt, (
            $users_pkey,
            $users_pkey,
            $data->{suppliers_fkey},
            $data->{stockitems_pkey},
            $data->{currencies_fkey},
            $data->{stockitem},
            $data->{description},
            $data->{purchaseprice},
            $users_pkey,
            $data->{currencies_fkey},
            $data->{stockitem},
            $data->{description},
            $data->{purchaseprice},
        ))->hash->{supplier_stockitem_pkey};
    };
    say $@ if $@;

    return $supplier_stockitem_pkey;
}

1;