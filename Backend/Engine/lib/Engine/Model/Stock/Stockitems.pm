package Engine::Model::Stock::Stockitems;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

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

1;