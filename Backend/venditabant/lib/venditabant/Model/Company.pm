package venditabant::Model::Company;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

has 'db';

sub upsert ($self, $companies_pkey, $users_pkey, $company) {

    my $customer_stmt = qq{
        INSERT INTO companies (insby, modby, company, name, registrationnumber,
                homepage, phone, languages_fkey, address1, address2, address3,
                zipcode, city, giro, invoiceref, email, tin, invoicecomment)
            VALUES ((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
            ON CONFLICT (company)
        DO UPDATE SET name = ?, registrationnumber = ?, homepage = ?, phone = ?,
            moddatetime = now(),
            modby = (SELECT userid FROM users WHERE users_pkey = ?),
            languages_fkey = ?,
            address1 = ?, address2 = ?, address3 = ?,
                zipcode = ?, city = ?, giro = ?, invoiceref = ?, email = ?, tin = ?, invoicecomment = ?
        RETURNING companies_pkey
    };

    my $customers_pkey = $self->db->query(
        $customer_stmt,
        (
            $users_pkey,
            $users_pkey,
            $company->{company},
            $company->{name},
            $company->{registrationnumber},
            $company->{homepage},
            $company->{phone},
            $company->{languages_fkey},
            $company->{address1},
            $company->{address2},
            $company->{address3},
            $company->{zipcode},
            $company->{city},
            $company->{giro},
            $company->{invoiceref},
            $company->{email},
            $company->{tin},
            $company->{invoicecomment},
            $company->{name},
            $company->{registrationnumber},
            $company->{homepage},
            $company->{phone},
            $users_pkey,
            $company->{languages_fkey},
            $company->{address1},
            $company->{address2},
            $company->{address3},
            $company->{zipcode},
            $company->{city},
            $company->{giro},
            $company->{invoiceref},
            $company->{email},
            $company->{tin},
            $company->{invoicecomment},
        )
    )->hash->{companies_pkey};

    return $customers_pkey;
}

async sub load_list_p ($self) {

    my $result = $self->db->select(
        'companies', undef
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;
    return $hash
}

async sub load_p ($self, $companies_pkey, $users_pkey) {

    my $result = $self->db->select(
        'companies', undef,
            {
                companies_pkey => $companies_pkey
            }
    );
    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;
    return $hash
}
1;