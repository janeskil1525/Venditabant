package Pricelists::Model::PricelistItems;
use Mojo::Base -base, -signatures, -async_await;

has 'db';


async sub load_list_items_p ($self, $companies_pkey, $pricelists_fkey) {

    my $pricelistitems_stmt = qq {
        SELECT pricelist_items_pkey, pricelist,
            (SELECT stockitem FROM stockitems WHERE stockitems_pkey = stockitems_fkey) as stockitem,
            price, fromdate, todate, stockitems_fkey
        FROM pricelists, pricelist_items
        WHERE pricelists_fkey = pricelists_pkey
            AND pricelists_pkey = ?
                AND companies_fkey = ?
        ORDER BY stockitem, fromdate, todate
    };
    my $result = await $self->db->query_p(
        $pricelistitems_stmt,
        (
            $pricelists_fkey, $companies_pkey
        )
    );

    my $hash;
    $hash = $result->hashes if $result->rows;
    return $hash;
}

sub insert_item ($self, $companies_pkey, $users_pkey, $pricelists_item) {

    my $pricelist_stmt = qq{
        INSERT INTO pricelist_items (pricelists_fkey, stockitems_fkey, price, fromdate, todate)
            VALUES (?,?,?,?,?)
        RETURNING pricelist_items_pkey
    };

    my $ppricelist_items_pkey = $self->db->query(
        $pricelist_stmt,
        (
            $pricelists_item->{pricelists_fkey},
            $pricelists_item->{stockitems_fkey},
            $pricelists_item->{price},
            $pricelists_item->{fromdate},
            $pricelists_item->{todate}
        )
    )->hash->{pricelist_items_pkey};

    return $ppricelist_items_pkey;
}

async sub load_list_items_raw_p ($self, $pricelists_pkey, $pricelisthead) {

    my $result = $self->db->query_p(
        'pricelist_items',
        undef,
            {
                pricelists_fkey => $pricelists_pkey
            }
    );

    my $hash;
    $hash = $result->hashes if $result->rows;
    return $hash;
}

1;