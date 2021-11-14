package venditabant::Model::Currency::Currencies;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

async sub upsert($self, $currency) {

    my $stmt = qq{
        INSERT INTO currencies (shortdescription, longdescription, description, seriesid)
            VALUES(?,?,?,?)
        ON CONFLICT (shortdescription)
        DO UPDATE SET moddatetime = now()
    };

    $self->db->query($stmt,(
        $currency->{shortdescription},
        $currency->{longdescription},
        $currency->{description},
        $currency->{seriesid},
    ));
}

async sub load_currency_list($self, $companies_pkey, $users_pkey) {

    my $result = $self->db->select('currencies',
        ["currencies_pkey", "shortdescription", "longdescription", "description", "seriesid"],
        undef,
        {order_by => {
                -asc => 'shortdescription'
            }
        }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows;

    return $hash;
}
1;