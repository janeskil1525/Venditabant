package venditabant::Helpers::Stockitems;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Stockitems;
use venditabant::Model::SalesorderItem;
use venditabant::Model::SalesorderHead;
use venditabant::Model::Customers;
use venditabant::Model::SalesorderItem;
use venditabant::Model::PricelistItems;

use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $stockitem) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $stockitems_pkey = venditabant::Model::Users->new(
            db => $db
        )->upsert(
            $companies_pkey, $stockitem
        );
        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;

    return $err ? $err : 'success';
}

async sub load_list_p ($self, $companies_pkey) {

    my $result = venditabant::Model::Stockitems->new(
        db => $self->pg->db
    )->load_list_p(
        $companies_pkey
    );

    return $result;
}

async sub load_list_mobile_nocust_p ($self, $companies_pkey) {

    my $response = $self->mobile_list_response();

    my $pricelists_pkey = $self->pg->db->select(
        'pricelists',
        ['pricelists_pkey'],
            {
                pricelist      => 'DEFAULT',
                companies_fkey => $companies_pkey,
            }
    )->hash->{pricelists_pkey};

    say "load_list_mobile_nocust_p " . $pricelists_pkey;
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
    return $response;
}

async sub load_list_mobile_p ($self, $companies_pkey, $cust) {

    my $db = $self->pg->db;

    my $customer = $self->pg->db->select(
        'customers',
        undef,
            {
                customer       => $cust,
                companies_fkey => $companies_pkey,
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
            )
    );

    my $response = $self->mobile_list_response();
    $response->{stockitems} = $result->hashes if $result and $result->rows > 0;

    my $salesorders_stmt = qq{
        SELECT stockitems_pkey, stockitem, description, quantity,  price
        FROM stockitems JOIN salesorder_items
            ON stockitems_pkey = stockitems_fkey
        JOIN salesorders ON salesorders_fkey = salesorders_pkey
        AND open = true AND salesorders.companies_fkey = ? AND customers_fkey = ?
    };

    $result = $self->pg->db->query(
        $salesorders_stmt,
        (
            $companies_pkey,
            $customer->{customers_pkey},
        )
    );

    $response->{salesorders} = $result->hashes if $result and $result->rows > 0;

    my $history_stmt = qq {
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

    return $response;
}

sub mobile_list_response ($self) {

    my $response->{history} = [];
    $response->{salesorders} = [];
    $response->{stockitems} = [];

    return $response;
}
1;