package venditabant::Model::Customer::Customers;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

sub upsert ($self, $companies_pkey, $users_pkey, $company) {

    my $customer_stmt = qq{
        INSERT INTO customers (insby, modby, customer, name, registrationnumber,
                homepage, phone, pricelists_fkey, companies_fkey, comment, languages_fkey)
            VALUES ((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?, ?, ?, ?,?,?,?)
            ON CONFLICT (customer, companies_fkey)
        DO UPDATE SET name = ?, registrationnumber = ?, homepage = ?, phone = ?,
            pricelists_fkey = ?, moddatetime = now(),
            modby = (SELECT userid FROM users WHERE users_pkey = ?),
            comment = ?, languages_fkey = ?
        RETURNING customers_pkey
    };

    my $customers_pkey = $self->db->query(
        $customer_stmt,
        (
            $users_pkey,
            $users_pkey,
            $company->{customer},
            $company->{name},
            $company->{registrationnumber},
            $company->{homepage},
            $company->{phone},
            $company->{pricelists_fkey},
            $companies_pkey,
            $company->{comment},
            $company->{languages_fkey},
            $company->{name},
            $company->{registrationnumber},
            $company->{homepage},
            $company->{phone},
            $company->{pricelists_fkey},
            $users_pkey,
            $company->{comment},
            $company->{languages_fkey},
        )
    )->hash->{customers_pkey};

    return $customers_pkey;
}

async sub load_customer ($self, $companies_pkey, $customer) {

    my $result = $self->db->select(
        'customers',
        undef,
            {
                companies_pkey => $companies_pkey,
                customer       => $customer
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}

async sub load_customer_from_pkey ($self, $companies_pkey, $customers_pkey) {

    my $result = $self->db->select(
        'customers',
        undef,
        {
            companies_pkey      => $companies_pkey,
            customers_pkey      => $customers_pkey
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}
1;