package venditabant::Model::SalesorderItem;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub delete_item ($self, $companies_pkey, $salesorders_pkey, $data) {
    my $salesorder_item_stmt = qq{
        DELETE FROM salesorder_items WHERE salesorders_fkey = ?
            AND stockitems_fkey = (SELECT stockitems_pkey FROM stockitems
                        WHERE companies_fkey = ? AND stockitem = ?)
    };

    $self->db->query(
        $salesorder_item_stmt,
            ($salesorders_pkey, $companies_pkey, $data->{stockitem})
    );
}

async sub upsert ($self, $companies_pkey, $salesorders_pkey, $users_pkey, $data) {

    my $salesorder_item_stmt = qq{
        INSERT INTO salesorder_items (
                insby, modby, salesorders_fkey, stockitems_fkey, quantity, price
            ) VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,
                    (SELECT stockitems_pkey FROM stockitems
                        WHERE companies_fkey = ? AND stockitem = ?), ?, ?)
            ON CONFLICT (salesorders_fkey, stockitems_fkey)
            DO UPDATE SET modby = (SELECT userid FROM users WHERE users_pkey = ?),
                        moddatetime = now(),
                        quantity = ?, price = ?
            RETURNING salesorder_items_pkey
    };

    my $salesorder_items_pkey = $self->db->query(
        $salesorder_item_stmt,
        (
            $users_pkey,
            $users_pkey,
            $salesorders_pkey,
            $companies_pkey,
            $data->{stockitem},
            $data->{quantity},
            $data->{price},
            $users_pkey,
            $data->{quantity},
            $data->{price},
        )
    )->hash->{salesorder_items_pkey};

    return $salesorder_items_pkey;
}

async sub get_orderitems ($self, $salesorders_pkey) {

    my $result = $self->db->select(
        'salesorder_items',
        undef,
            {
                salesorders_fkey => $salesorders_pkey
            }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}
1;