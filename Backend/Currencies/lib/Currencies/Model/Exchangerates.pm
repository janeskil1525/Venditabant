package Currencies::Model::Exchangerates;
use Mojo::Base -base, -signatures, -async_await;

has 'db';

async sub upsert_p($self, $exchangerate) {

    my $stmt = qq {
        INSERT INTO currencies_exchangerates
            (base_currencies_fkey, currencies_fkey, ratedate, value, seriesid, seriesname, unit)
        VALUES ((SELECT currencies_pkey FROM currencies WHERE shortdescription = 'SEK'),
            (SELECT currencies_pkey FROM currencies WHERE seriesid = ?),?,?,?,?,?)
        ON CONFLICT (currencies_fkey, ratedate)
        DO UPDATE SET moddatetime = now(), value = ?
    };

    $self->db->query($stmt,
        $exchangerate->{seriesid},
        $exchangerate->{ratedate},
        $exchangerate->{value},
        $exchangerate->{seriesid},
        $exchangerate->{seriesname},
        $exchangerate->{unit},
        $exchangerate->{value},
    );
}
1;