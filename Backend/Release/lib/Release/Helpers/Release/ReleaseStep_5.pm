package Release::Helpers::Release::ReleaseStep_5;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub step ($self, $companies_pkey) {
    my $stmt = qq{
        INSERT INTO suppliers (companies_fkey, supplier, name)
            VALUES (?,'DEFAULT', 'DEFAULT')
        RETURNING suppliers_pkey;
    };

    my $suppliers_pkey = $self->db->query(
        $stmt,($companies_pkey)
    )->hash->{suppliers_pkey};

    my $result = $self->db->select(
        'stockitems',['*'],
            {
                companies_fkey => $companies_pkey
            }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows() > 0;

    if (defined $hash) {
        my $stmt = qq{
            INSERT INTO supplier_stockitem (suppliers_fkey, stockitems_fkey, currencies_fkey, stockitem, description, price)
            VALUES (?,?,(SELECT currencies_pkey FROM currencies WHERE shortdescription = 'SEK'), ?, ?, 0)
        };
        foreach my $stockitem (@{$hash}) {
            $self->db->query($stmt,
                (
                    $suppliers_pkey,
                    $stockitem->{stockitems_pkey},
                    $stockitem->{stockitem},
                    $stockitem->{description}
                )
            );
        }
    }
}

1;