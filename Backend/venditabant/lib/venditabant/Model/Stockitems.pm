package venditabant::Model::Stockitems;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

sub upsert ($self, $companies_pkey, $stockitem) {

    my $stockitem_stmt = qq{
        INSERT INTO stockitems (stockitem, description, companies_fkey) VALUES (?,?, ?)
            ON CONFLICT (stockitem, companies_fkey) DO UPDATE SET description = ?
        RETURNING stockitems_pkey
    };

    my $stockitems_pkey = $self->db->query(
        $stockitem_stmt,
            (
                $stockitem->{stockitem},
                $stockitem->{description},
                $companies_pkey,
                $stockitem->{description}
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