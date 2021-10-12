package venditabant::Model::CustomerAddress;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'db';

async sub insert_p ($self, $companies_pkey, $users_pkey, $data) {

    my $stmt = qq {
        INSERT INTO customer_addresses (insby, modby, customers_fkey, type, name, address1, address2, address3,
                                        city, zipcode, country, mailadresses, invoicedays_fkey)
            VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),
                ?,?,?,?,?,?,?,?,?,?,?)
        RETURNING customer_addresses_pkey;
    };

    my $customer_addresses_pkey= $self->db->query(
        $stmt,
        (
            $users_pkey,
            $users_pkey,,
            $data->{customers_fkey},
            $data->{type},
            $data->{name},
            $data->{address1},
            $data->{address2},
            $data->{address3},
            $data->{city},
            $data->{zipcode},
            $data->{country},
            $data->{mailadresses},
            $data->{invoicedays_fkey},
        )
    )->hash->{customer_addresses_pkey};

    return $customer_addresses_pkey;

}

async sub update_p ($self, $companies_pkey, $users_pkey, $data) {

    my $stmt = qq {
        UPDATE customer_addresses SET
            modby = (SELECT userid FROM users WHERE users_pkey = ?),
            moddatetime = now(),
            name = ?, address1 = ?, address2 = ?, address3 = ?,
            city = ?, zipcode = ?, country = ?, mailadresses = ?, invoicedays_fkey = ?
        WHERE customer_addresses_pkey = ?
    };

    $self->db->query(
        $stmt,
        (
            $users_pkey,
            $data->{name},
            $data->{address1},
            $data->{address2},
            $data->{address3},
            $data->{city},
            $data->{zipcode},
            $data->{country},
            $data->{mailadresses},
            $data->{invoicedays_fkey},
            $data->{customer_addresses_pkey}
        )
    );
    return $data->{customer_addresses_pkey};
}

async sub load_invoice_address_p($self, $customers_pkey) {

    my $result = $self->db->select(
        'customer_addresses',
        undef,
        {
            customers_fkey => $customers_pkey,
            type           => 'INVOICE'
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}
1;