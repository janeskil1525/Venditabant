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


1;