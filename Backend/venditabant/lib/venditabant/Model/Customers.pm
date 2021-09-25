package venditabant::Model::Customers;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

sub upsert ($self, $companies_pkey, $company) {

    my $customer_stmt = qq{
        INSERT INTO customers (customer, name, registrationnumber,
                homepage, phone, pricelists_fkey, companies_fkey)
            VALUES (?,?,?, ?, ?, (
                SELECT pricelists_pkey FROM pricelists WHERE pricelist = ? AND  companies_fkey = ?), ?)
            ON CONFLICT (customer, companies_fkey)
        DO UPDATE SET name = ?, registrationnumber = ?, homepage = ?, phone = ?,
            pricelists_fkey = (
                SELECT pricelists_pkey FROM pricelists
                    WHERE pricelist = ? AND companies_fkey = ?
            )
        RETURNING customers_pkey
    };

    my $customers_pkey = $self->db->query(
        $customer_stmt,
        (
            $company->{customer},
            $company->{name},
            $company->{registrationnumber},
            $company->{homepage},
            $company->{phone},
            $company->{pricelist},
            $companies_pkey,
            $companies_pkey,
            $company->{name},
            $company->{registrationnumber},
            $company->{homepage},
            $company->{phone},
            $company->{pricelist},
            $companies_pkey,
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
1;