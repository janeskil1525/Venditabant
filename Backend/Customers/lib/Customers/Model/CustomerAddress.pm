package Customers::Model::CustomerAddress;
use Mojo::Base -base, -signatures, -async_await;

has 'db';

sub insert ($self, $companies_pkey, $users_pkey, $data) {

    my $stmt = qq {
        INSERT INTO customer_addresses (insby, modby, customers_fkey, type, name, address1, address2, address3,
                                        city, zipcode, country, mailadresses, invoicedays_fkey, comment)
            VALUES (
                    (SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),
                ?,?,?,?,?,?,?,?,?,?,?,?)
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
            $data->{comment},
        )
    )->hash->{customer_addresses_pkey};

    return $customer_addresses_pkey;

}

async sub insert_p ($self, $companies_pkey, $users_pkey, $data) {

    my $customer_addresses_pkey = $self->insert(
        $companies_pkey, $users_pkey, $data
    );
    return $customer_addresses_pkey;

}

sub update ($self, $companies_pkey, $users_pkey, $data) {

    my $stmt = qq {
        UPDATE customer_addresses SET
            modby = (SELECT userid FROM users WHERE users_pkey = ?),
            moddatetime = now(),
            name = ?, address1 = ?, address2 = ?, address3 = ?,
            city = ?, zipcode = ?, country = ?, mailadresses = ?,
            invoicedays_fkey = ?, comment = ?
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
            $data->{comment},
            $data->{customer_addresses_pkey},
        )
    );
    return $data->{customer_addresses_pkey};
}

async sub update_p ($self, $companies_pkey, $users_pkey, $data) {

    my $customer_addresses_pkey = $self->update(
        $companies_pkey, $users_pkey, $data
    );
    return $customer_addresses_pkey;
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

sub load_invoice_address($self, $customers_pkey) {

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

async sub load_delivery_address_fromname_p ($self, $customers_pkey, $name) {

    my $result = $self->db->select(
        'customer_addresses',
        undef,
        {
            customers_fkey => $customers_pkey,
            name           => $name,
            type           => 'DELIVERY'
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}

async sub load_delivery_address_p ($self, $customer_addresses_pkey) {

    my $result = $self->db->select(
        'customer_addresses',
        undef,
        {
            customer_addresses_pkey => $customer_addresses_pkey
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}

async sub load_delivery_address_list_p($self, $customers_pkey) {

    my $result = $self->db->select(
        'customer_addresses',
        undef,
        {
            customers_fkey => $customers_pkey,
            type           => 'DELIVERY'
        }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}

sub address_type_exists($self, $companies_pkey, $users_pkey, $customers_fkey, $type) {

    say "customers_fkey " . $customers_fkey;
    my $stmt = qq{
        SELECT COUNT(*) as exists FROM customer_addresses WHERE customers_fkey = ? AND type = ?
    };

    my $exists;
    $exists = $self->db->query(
        $stmt, ($customers_fkey, $type)
    )->hash->{exists};

    return $exists;
}

async sub address_type_exists_p($self, $companies_pkey, $users_pkey, $customers_fkey, $type) {

    say "customers_fkey " . $customers_fkey;
    my $stmt = qq{
        SELECT COUNT(*) as exists FROM customer_addresses WHERE customers_fkey = ? AND type = ?
    };

    my $exists;
    $exists = $self->db->query(
        $stmt, ($customers_fkey, $type)
    )->hash->{exists};

    return $exists;
}

1;