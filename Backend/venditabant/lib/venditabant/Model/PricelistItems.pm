package venditabant::Model::PricelistItems;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

has 'db';


async sub load_list_items_p ($self, $companies_pkey, $pricelisthead) {

    my $pricelistitems_stmt = qq {
        SELECT pricelist_items_pkey, '$pricelisthead' as pricelist,
            (SELECT stockitem FROM stockitems WHERE stockitems_pkey = stockitems_fkey) as stockitem,
            price, fromdate, todate
        FROM pricelists, pricelist_items
        WHERE pricelists_fkey = pricelists_pkey
            AND pricelist = ?
                AND companies_fkey = ?
    };
    my $result = await $self->db->query_p(
        $pricelistitems_stmt,
        (
            $pricelisthead, $companies_pkey
        )
    );

    my $hash;
    $hash = $result->hashes if $result->rows;
    return $hash;
}

sub insert_item ($self, $companies_pkey, $pricelists_item) {

    my $pricelist_stmt = qq{
        INSERT INTO pricelist_items (pricelists_fkey, stockitems_fkey, price, fromdate, todate)
            VALUES (
                (SELECT pricelists_pkey FROM pricelists WHERE pricelist = ? AND companies_fkey = ?),
                (SELECT stockitems_pkey FROM stockitems WHERE stockitem = ? AND companies_fkey = ?),
                ?,?, ?)
        RETURNING pricelist_items_pkey
    };

    my $ppricelist_items_pkey = $self->db->query(
        $pricelist_stmt,
        (
            $pricelists_item->{pricelist},
            $companies_pkey,
            $pricelists_item->{stockitem},
            $companies_pkey,
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