package venditabant::Model::Pricelists;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';


async sub get_pricelist_pkey($self, $companies_pkey, $pricelist) {

    my $result = await $self->db->select_p('pricelists',
        undef,
        {
            companies_fkey => $companies_pkey,
            pricelist      => $pricelist
        }
    );

    my $hash;
    $hash = $result->hash->{pricelists_pkey} if $result and $result->rows;
    return $hash;
}

async sub load_list_heads_p ($self, $companies_pkey) {

    my $result = await $self->db->select_p('pricelists',
        undef,
        {
            companies_fkey => $companies_pkey
        }
    );

    my $hash;
    $hash = $result->hashes if $result->rows;
    return $hash;
}

sub upsert ($self, $companies_pkey, $pricelists) {

    my $pricelist_stmt = qq{
        INSERT INTO pricelists (pricelist, companies_fkey) VALUES (?,?)
            ON CONFLICT (pricelist, companies_fkey) DO NOTHING
        RETURNING pricelists_pkey
    };

    my $pricelists_pkey = $self->db->query(
        $pricelist_stmt,
        (
            $pricelists->{pricelist},
            $companies_pkey
        )
    )->hash->{pricelists_pkey};

    return $pricelists_pkey;
}

1;