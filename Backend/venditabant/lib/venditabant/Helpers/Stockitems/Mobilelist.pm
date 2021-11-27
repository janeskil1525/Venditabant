package venditabant::Helpers::Stockitems::Mobilelist;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'pg';

async sub load_list_mobile_nocust_p ($self, $companies_pkey) {

    say "load_list_mobile_nocust_p";
    my $err;
    my $response = $self->mobile_list_response();
    eval {
        # my $pricelists_pkey = $self->pg->db->select(
        #     'pricelists',
        #     [ 'pricelists_pkey' ],
        #     {
        #         pricelist      => 'DEFAULT',
        #         companies_fkey => $companies_pkey,
        #     }
        # )->hash->{pricelists_pkey};

    #     my $mobilelist_stmt = qq{
    #     SELECT stockitems_pkey, stockitem, description, 0 as quantity,  price
    #         FROM stockitems JOIN pricelist_items
    #         ON stockitems_pkey = stockitems_fkey AND companies_fkey = ?
	# 			AND pricelists_fkey = ?
	# 		AND pricelist_items_pkey = (
	# 			SELECT pricelist_items_pkey FROM pricelist_items
	# 				WHERE stockitems_pkey = stockitems_fkey
	# 					AND pricelists_fkey = ?
	# 			AND fromdate = (SELECT MAX(fromdate) FROM pricelist_items
	# 							WHERE stockitems_pkey = stockitems_fkey AND todate >= now()))
	# 			AND todate >= now()
    #
    # };

        my $mobilelist_stmt = qq{
            SELECT stockitems_pkey, stockitem, description, 0 as quantity,  get_price(?,stockitems_pkey, 0) as price
            FROM stockitems
        };
say $mobilelist_stmt;
        my $result = $self->pg->db->query(
            $mobilelist_stmt,
            ($companies_pkey)
        );

        my $hash;
        $hash = $result->hashes if $result and $result->rows;

        $response->{stockitems} = $hash;
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Stockitems;', 'load_list_mobile_nocust_p', $err
    ) if $err;

    return $response;
}

async sub load_list_mobile_p ($self, $companies_pkey, $customers_fkey, $customer_addresses_pkey) {

    my $err;
    my $response = $self->mobile_list_response();
    my $db = $self->pg->db;

    eval {

        my $mobilelist_stmt = qq{
        SELECT stockitems_pkey, stockitem, description, 0 as quantity,  get_price(?, stockitems_pkey, ?) as price
            FROM stockitems WHERE
				companies_fkey = ? AND stockitems_pkey NOT IN(
				    SELECT stockitems_pkey
                    FROM stockitems JOIN salesorder_items
                        ON stockitems.stockitem = salesorder_items.stockitem AND stockitems.companies_fkey = ?
                    JOIN salesorders ON salesorders_fkey = salesorders_pkey
                    AND open = true AND salesorders.companies_fkey = ? AND customers_fkey = ?
                    AND customer_addresses_fkey = ?
				)
    };

        my $result = $self->pg->db->query(
            $mobilelist_stmt,
            (
                $companies_pkey,
                $customers_fkey,
                $companies_pkey,
                $companies_pkey,,
                $companies_pkey,
                $customers_fkey,
                $customer_addresses_pkey,
            )
        );

        $response->{stockitems} = $result->hashes if $result and $result->rows > 0;

        my $salesorders_stmt = qq{
        SELECT salesorder_items_pkey, stockitem, description, quantity,  price
        FROM salesorder_items
        JOIN salesorders ON salesorders_fkey = salesorders_pkey
        AND open = true AND salesorders.companies_fkey = ? AND customers_fkey = ?
        AND customer_addresses_fkey = ?
    };

        $result = $self->pg->db->query(
            $salesorders_stmt,
            (
                $companies_pkey,
                $customers_fkey,
                $customer_addresses_pkey,
            )
        );

        $response->{salesorders} = $result->hashes if $result and $result->rows > 0;

        my $history_stmt = qq{
            SELECT DISTINCT stockitems_pkey, stockitems.stockitem, description,
                quantity,  price, deliverydate
            FROM stockitems JOIN salesorder_statistics ON stockitems.stockitem = salesorder_statistics.stockitem
                AND stockitems.companies_fkey = ? AND customers_fkey = ? AND customer_addresses_fkey = ?
                AND stockitems_pkey NOT IN(
                        SELECT stockitems_pkey
                        FROM stockitems JOIN salesorder_items
                            ON stockitems.stockitem = salesorder_items.stockitem
                        JOIN salesorders ON salesorders_fkey = salesorders_pkey
                        AND open = true AND salesorders.companies_fkey = ? AND customers_fkey = ?
                            AND customer_addresses_fkey = ?
                    )
            ORDER BY deliverydate DESC
        };
say " load_list_mobile_p " . $companies_pkey . " " . $customers_fkey . " " . $customer_addresses_pkey;
        $result = $self->pg->db->query(
            $history_stmt,
            (
                $companies_pkey,
                $customers_fkey,
                $customer_addresses_pkey,
                $companies_pkey,
                $customers_fkey,
                $customer_addresses_pkey,
            )
        );

        $response->{history} = $result->hashes if $result and $result->rows > 0;
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Stockitems;', 'load_list_mobile_p', $err
    ) if $err;

    return $response;
}

sub mobile_list_response ($self) {

    my $response->{history} = [];
    $response->{salesorders} = [];
    $response->{stockitems} = [];

    return $response;
}
1;