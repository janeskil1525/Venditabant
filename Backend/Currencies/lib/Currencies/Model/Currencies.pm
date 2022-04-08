package Currencies::Model::Currencies;
use Mojo::Base -base, -signatures, -async_await;

has 'db';

async sub upsert_p($self, $currency) {

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

async sub load_currency_list_p($self, $companies_pkey, $users_pkey) {

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

async sub load_currency_pkey_p($self, $shortdescription) {

    return $self->load_currency_pkey($shortdescription);
}

sub load_currency_pkey($self, $shortdescription) {

    my $result = $self->db->select(
        'currencies',
        ['currencies_pkey'],
        {
            shortdescription => $shortdescription
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}
1;