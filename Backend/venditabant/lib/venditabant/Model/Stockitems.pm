package venditabant::Model::Stockitems;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

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
say Dumper($stockitem);
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