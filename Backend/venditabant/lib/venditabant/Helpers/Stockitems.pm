package venditabant::Helpers::Stockitems;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Stockitems;
use venditabant::Model::Pricelists;
use venditabant::Model::PricelistItems;
use venditabant::Helpers::Pricelist::Pricelists;
use venditabant::Model::Supplier::Stockitems;
use venditabant::Model::Supplier::Suppliers;
use venditabant::Model::Currency::Currencies;

use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $users_pkey, $stockitem) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    my $pricelist_item;

    eval {
        $pricelist_item = venditabant::Model::PricelistItems->new(db => $db);
    };
    say "Error 1 " . $@ if $@;

    eval {
        my $stockitems_pkey = venditabant::Model::Stockitems->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $stockitem
        );

        my $item = await venditabant::Helpers::Pricelist::Pricelists->new(
            pg => $self->pg
        )->prepare_upsert_from_stockitem(
            $companies_pkey, $stockitems_pkey, $stockitem->{price}
        );


        $pricelist_item->insert_item(
            $companies_pkey, $item
        );

        my $supplier = await venditabant::Model::Supplier::Suppliers->new(
            db => $db
        )->load_supplier(
            $companies_pkey, $users_pkey, 'DEFAULT'
        );

        $stockitem->{suppliers_fkey} = $supplier->{suppliers_pkey};
        $stockitem->{stockitems_pkey} = $stockitems_pkey;
        if($stockitem->{currencies_fkey} == 0) {
             my $currency = await venditabant::Model::Currency::Currencies->new(
                db => $db
            )->load_currency_pkey(
                'SEK'
            );
            $stockitem->{currencies_fkey} = $currency->{currencies_pkey};
        }
        venditabant::Model::Supplier::Stockitems->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $stockitem
        );

        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Stockitems', 'upsert', $@
    ) if $err;

    return 'success' unless $err;
    return $err;
}

async sub load_list_p ($self, $companies_pkey) {

    my $stmt = qq {
        SELECT stockitems_pkey, stockitems.stockitem, stockitems.description, active, stockitems.stocked,
                pricelist_items.price, po.price as purchaseprice
            ,units.param_value as unit, accounts.param_value as account
            ,vat.param_value as vat, productgroup.param_value as productgroup,
            currencies_pkey, shortdescription, supplier, suppliers_pkey
             FROM stockitems JOIN pricelist_items ON stockitems_pkey = stockitems_fkey
				AND pricelists_fkey = (SELECT pricelists_pkey FROM pricelists WHERE pricelist = 'DEFAULT'
									  AND stockitems.companies_fkey = companies_fkey)
			AND pricelist_items_pkey = (
				SELECT MAX(pricelist_items_pkey) FROM pricelist_items
					WHERE stockitems_pkey = stockitems_fkey
						AND pricelists_fkey = (SELECT pricelists_pkey FROM pricelists
											   WHERE pricelist = 'DEFAULT' AND stockitems.companies_fkey = companies_fkey)
				AND fromdate = (SELECT MAX(fromdate) FROM pricelist_items, pricelists
								WHERE pricelist = 'DEFAULT' AND pricelists_pkey = pricelists_fkey AND
								stockitems_pkey = stockitems_fkey AND todate >= now()))
				AND todate >= now()
			JOIN parameters_items as units ON units.parameters_items_pkey = units_fkey
			JOIN parameters_items as accounts ON accounts.parameters_items_pkey = accounts_fkey
			JOIN parameters_items as vat ON vat.parameters_items_pkey = vat_fkey
			JOIN parameters_items as productgroup ON productgroup.parameters_items_pkey = productgroup_fkey
			JOIN supplier_stockitem as po ON po.stockitems_fkey = stockitems_pkey
			JOIN suppliers as su ON su.suppliers_pkey = po.suppliers_fkey AND su.supplier ='DEFAULT'
			JOIN currencies ON currencies_pkey = currencies_fkey
        WHERE stockitems.companies_fkey = ?
    };

    my $err;
    my $hash;
    eval {
        my $result = $self->pg->db->query(
            $stmt,
            ($companies_pkey)
        );

        $hash = $result->hashes if $result and $result->rows > 0;
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Stockitems;', 'load_list_p', $@
    ) if $err;

    return $hash;
}

async sub load_list_mobile_nocust_p ($self, $companies_pkey) {

    my $err;
    my $response = $self->mobile_list_response();
    eval {
        my $pricelists_pkey = $self->pg->db->select(
            'pricelists',
            [ 'pricelists_pkey' ],
            {
                pricelist      => 'DEFAULT',
                companies_fkey => $companies_pkey,
            }
        )->hash->{pricelists_pkey};

        my $mobilelist_stmt = qq{
        SELECT stockitems_pkey, stockitem, description, 0 as quantity,  price
            FROM stockitems JOIN pricelist_items
            ON stockitems_pkey = stockitems_fkey AND companies_fkey = ?
				AND pricelists_fkey = ?
			AND pricelist_items_pkey = (
				SELECT pricelist_items_pkey FROM pricelist_items
					WHERE stockitems_pkey = stockitems_fkey
						AND pricelists_fkey = ?
				AND fromdate = (SELECT MAX(fromdate) FROM pricelist_items
								WHERE stockitems_pkey = stockitems_fkey AND todate >= now()))
				AND todate >= now()

    };

        my $result = $self->pg->db->query(
            $mobilelist_stmt,
            ($companies_pkey, $pricelists_pkey, $pricelists_pkey)
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

async sub load_list_mobile_p ($self, $companies_pkey, $customer_addresses_pkey) {

    my $err;
    my $response = $self->mobile_list_response();
    my $db = $self->pg->db;

    eval {
        my $customer = $self->pg->db->select(
            [ 'customers', [ 'customer_addresses', customers_fkey => 'customers_pkey' ] ],
            [ 'pricelists_fkey', 'customers_pkey' ],
            {
                customer_addresses_pkey => $customer_addresses_pkey,
                companies_fkey          => $companies_pkey,
            }
        )->hash;

        my $mobilelist_stmt = qq{
        SELECT stockitems_pkey, stockitem, description, 0 as quantity,  price
            FROM stockitems JOIN pricelist_items
            ON stockitems_pkey = stockitems_fkey AND companies_fkey = ?
				AND pricelists_fkey = ?
			AND pricelist_items_pkey = (
				SELECT pricelist_items_pkey FROM pricelist_items
					WHERE stockitems_pkey = stockitems_fkey
						AND pricelists_fkey = ?
				AND fromdate = (SELECT MAX(fromdate) FROM pricelist_items
								WHERE stockitems_pkey = stockitems_fkey AND todate >= now()))
				AND todate >= now()
				AND stockitems_pkey NOT IN(
				    SELECT stockitems_pkey
                    FROM stockitems JOIN salesorder_items
                        ON stockitems_pkey = stockitems_fkey
                    JOIN salesorders ON salesorders_fkey = salesorders_pkey
                    AND open = true AND salesorders.companies_fkey = ? AND customers_fkey = ?
                    AND customer_addresses_fkey = ?
				)
    };

        my $result = $self->pg->db->query(
            $mobilelist_stmt,
            (
                $companies_pkey,
                $customer->{pricelists_fkey},
                $customer->{pricelists_fkey},
                $companies_pkey,
                $customer->{customers_pkey},
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
                $customer->{customers_pkey},
                $customer_addresses_pkey,
            )
        );

        $response->{salesorders} = $result->hashes if $result and $result->rows > 0;

        my $history_stmt = qq{
        SELECT DISTINCT stockitems_pkey, stockitem, description,
            quantity,  price, deliverydate
        FROM stockitems JOIN salesorder_statistics ON stockitems_pkey = stockitems_fkey
            AND stockitems.companies_fkey = ? AND customers_fkey = ?
            AND stockitems_pkey NOT IN(
				    SELECT stockitems_pkey
                    FROM stockitems JOIN salesorder_items
                        ON stockitems_pkey = stockitems_fkey
                    JOIN salesorders ON salesorders_fkey = salesorders_pkey
                    AND open = true AND salesorders.companies_fkey = ? AND customers_fkey = ?
				)
	ORDER BY deliverydate DESC
    };

        $result = $self->pg->db->query(
            $history_stmt,
            (
                $companies_pkey,
                $customer->{customers_pkey},
                $companies_pkey,
                $customer->{customers_pkey},
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