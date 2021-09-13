package venditabant::Model::Stockitems;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

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

1;