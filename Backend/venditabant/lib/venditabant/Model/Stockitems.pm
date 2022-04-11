package venditabant::Model::Stockitems;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

sub upsert ($self, $companies_pkey, $users_pkey, $stockitem) {

    my $stockitem_stmt = qq{
        INSERT INTO stockitems (insby, modby, stockitem, description, companies_fkey,
                        units_fkey, active, stocked, accounts_fkey, vat_fkey, productgroup_fkey) VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?, ?,?,?, ?, ?, ?)
            ON CONFLICT (stockitem, companies_fkey)
            DO UPDATE SET description = ?, moddatetime = now(),
                modby = (SELECT userid FROM users WHERE users_pkey = ?),
                units_fkey = ?, active = ?, stocked = ?, accounts_fkey = ?,
                    vat_fkey = ?, productgroup_fkey = ?
        RETURNING stockitems_pkey
    };

    my $stockitems_pkey;

    $stockitems_pkey = $self->db->query(
        $stockitem_stmt,
        (
            $users_pkey,
            $users_pkey,
            $stockitem->{stockitem},
            $stockitem->{description},
            $companies_pkey,
            $stockitem->{units_fkey},
            $stockitem->{active},
            $stockitem->{stocked},
            $stockitem->{accounts_fkey},
            $stockitem->{vat_fkey},
            $stockitem->{productgroup_fkey},
            $stockitem->{description},
            $users_pkey,
            $stockitem->{units_fkey},
            $stockitem->{active},
            $stockitem->{stocked},
            $stockitem->{accounts_fkey},
            $stockitem->{vat_fkey},
            $stockitem->{productgroup_fkey},
        )
    )->hash->{stockitems_pkey};

    return $stockitems_pkey;
}

async sub load_complete_item($self, $companies_pkey, $users_pkey, $stockitems_pkey) {

    my $stmt = qq {
        SELECT *, (
            SELECT param_value FROM parameters_items WHERE parameters_items_pkey = units_fkey
        ) as units,(
            SELECT param_value FROM parameters_items WHERE parameters_items_pkey = accounts_fkey
        ) as accounts,(
            SELECT param_value FROM parameters_items WHERE parameters_items_pkey = vat_fkey
        ) as vat,(
            SELECT param_value FROM parameters_items WHERE parameters_items_pkey = productgroup_fkey
        ) as productgroup
        FROM stockitems WHERE stockitems_pkey = ? AND companies_fkey = ?
    };

    my $result = $self->db->query(
        $stmt,
            (
                $stockitems_pkey,
                $companies_pkey
            )
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;

    return $hash;
}

async sub load_list_p ($self, $companies_pkey) {

    my $load_stmt = qq {
        SELECT stockitems_pkey, stockitem, description, active, stocked, purchaseprice
            FROM stockitems
        WHERE companies_fkey = ?
    };

    my $list = $self->db->query($load_stmt,($companies_pkey));

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}

async sub load_list_mobile_p ($self, $companies_pkey, $company) {

    my $load_stmt = qq {
        SELECT stockitems_pkey, stockitem, description, 0 as quantity, 0.0 as price
            FROM stockitems
        WHERE companies_fkey = ?
    };

    my $list = $self->db->query($load_stmt,($companies_pkey));

    my $hashes;
    $hashes = $list->hashes if $list->rows > 0;

    return $hashes;
}
1;