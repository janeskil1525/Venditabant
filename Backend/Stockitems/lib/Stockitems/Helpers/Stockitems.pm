package Stockitems::Helpers::Stockitems;
use Mojo::Base -base, -signatures, -async_await;

use Stockitems::Model::Stockitems;
use Stockitems::Model::Counter;
use Suppliers::Model::Stockitems;
use Pricelists::Model::PricelistItems;
use Pricelists;
use Suppliers;
use Currencies;

use Data::Dumper;

has 'pg';

sub get_new_stockitem_id($self, $companies_pkey, $users_pkey) {
    my $stockitemid= Stockitems::Model::Counter->new(
        db => $self->pg->db
    )->nextid(
        $companies_pkey, $users_pkey, 'stockitems'
    );
    $stockitemid .= '00000000000';
    my $stockitem = substr($stockitemid,0,10);

    return $stockitem;
}

sub upsert ($self, $companies_pkey, $users_pkey, $stockitem) {
    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    my $pricelist_item;

    my $stockitems_pkey = 0;
    eval {
        $stockitems_pkey = Stockitems::Model::Stockitems->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $stockitem
        );

        my $item = Pricelists->new(
            pg => $self->pg
        )->prepare_upsert_from_stockitem(
            $companies_pkey, $stockitems_pkey, $stockitem->{price}
        );

        Pricelists::Model::PricelistItems->new(
            db => $db
        )->insert_item(
            $companies_pkey, $users_pkey, $item
        );

        my $supplier = Suppliers->new(
            pg => $self->pg
        )->load_supplier(
            $companies_pkey, $users_pkey, 'DEFAULT'
        );

        $stockitem->{suppliers_fkey} = $supplier->{suppliers_pkey};
        $stockitem->{stockitems_pkey} = $stockitems_pkey;
        if(!$stockitem->{currencies_fkey} or $stockitem->{currencies_fkey} == 0) {
            my $currency = Currencies->new(
                pg => $self->pg
            )->load_currency_pkey(
                'SEK'
            );
            $stockitem->{currencies_fkey} = $currency->{currencies_pkey};
        }
        Suppliers::Model::Stockitems->new(
            db => $db
        )->upsert_supplieritem(
            $companies_pkey, $users_pkey, $stockitem
        );

        $tx->commit();
    };
    say  $@ if $@;

    return $stockitems_pkey;
}

async sub upsert_p ($self, $companies_pkey, $users_pkey, $stockitem) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    my $pricelist_item;

    eval {
        $pricelist_item = Pricelists->new(db => $db);
    };
    say "Error 1 " . $@ if $@;

    eval {
        my $stockitems_pkey = Stockitems::Model::Stockitems->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $stockitem
        );

        my $item = await Pricelists->new(
            pg => $self->pg
        )->prepare_upsert_from_stockitem_p(
            $companies_pkey, $stockitems_pkey, $stockitem->{price}
        );

        await $pricelist_item->insert_item_p(
            $companies_pkey, $item
        );

        my $supplier = await Suppliers->new(
            db => $db
        )->load_supplier_p(
            $companies_pkey, $users_pkey, 'DEFAULT'
        );

        $stockitem->{suppliers_fkey} = $supplier->{suppliers_pkey};
        $stockitem->{stockitems_pkey} = $stockitems_pkey;
        if($stockitem->{currencies_fkey} == 0) {
             my $currency = await Currencies->new(
                db => $db
            )->load_currency_pkey_p(
                'SEK'
            );
            $stockitem->{currencies_fkey} = $currency->{currencies_pkey};
        }
        Suppliers->new(
            db => $db
        )->upsert_supplieritem(
            $companies_pkey, $users_pkey, $stockitem
        );

        $tx->commit();
    };
    say  $@ if $@;

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

    return $hash;
}


1;