package Engine::Model::Salesorder::Item;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';


async sub delete_item ($self, $companies_pkey, $salesorders_pkey, $data) {

    my $salesorder_item_stmt = qq{
        DELETE FROM salesorder_items WHERE salesorders_fkey = ?
            AND stockitems_fkey = ?
    };

    $self->db->query(
        $salesorder_item_stmt,
            ($salesorders_pkey, $data->{stockitems_fkey})
    );
}

async sub upsert ($self, $companies_pkey, $salesorders_pkey, $users_pkey, $data) {

    my $salesorder_item_stmt = qq{
        INSERT INTO salesorder_items (
                insby, modby, salesorders_fkey, stockitem, description,
                quantity, price, customer_addresses_fkey, vat, discount, unit, account
            ) VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?,?,?,?,?,?,?,?)
            ON CONFLICT (salesorders_fkey, stockitem)
            DO UPDATE SET modby = (SELECT userid FROM users WHERE users_pkey = ?),
                        moddatetime = now(),
                        quantity = ?, price = ?, customer_addresses_fkey = ?,
                        description = ?, vat = ?, discount = ?, deliverydate = now(),
                        unit = ?, account = ?
            RETURNING salesorder_items_pkey
    };

    my $log = Log::Log4perl->get_logger();

    my $salesorder_items_pkey = 0;
    my $err;
    eval {
        $salesorder_items_pkey = $self->db->query(
            $salesorder_item_stmt,
            (
                $users_pkey,
                $users_pkey,
                $salesorders_pkey,
                $data->{stockitem},
                $data->{description},
                $data->{quantity},
                $data->{price},
                $data->{customer_addresses_fkey},
                $data->{vat},
                $data->{discount},
                $data->{unit},
                $data->{account},
                $users_pkey,
                $data->{quantity},
                $data->{price},
                $data->{customer_addresses_fkey},
                $data->{description},
                $data->{vat},
                $data->{discount},
                $data->{unit},
                $data->{account},
            )
        )->hash->{salesorder_items_pkey};
    };
    $err = $@ if $@;
    $log->error(
        "Engine::Model::Salesorder::Item " . $err
    ) if $err;


    return $salesorder_items_pkey;
}

1;