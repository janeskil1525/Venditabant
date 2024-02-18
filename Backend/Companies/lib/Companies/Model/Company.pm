package Companies::Model::Company;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

has 'db';

sub upsert ($self, $companies_pkey, $users_pkey, $company) {

    my $customer_stmt = qq{
        UPDATE companies  SET name = ?, registrationnumber = ?, homepage = ?, phone = ?,
            moddatetime = now(),
            modby = (SELECT userid FROM users WHERE users_pkey = ?),
            languages_fkey = ?,
            address1 = ?, address2 = ?, address3 = ?,
                zipcode = ?, city = ?, giro = ?, invoiceref = ?, email = ?, tin = ?, invoicecomment = ?
        WHERE companies_pkey = ?
        RETURNING companies_pkey
    };

    #say Dumper($customer_stmt);
    my $customers_pkey = $self->db->query(
        $customer_stmt,
        (
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
            $companies_pkey,
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

async sub get_language_fkey_p($self, $companies_pkey, $users_pkey) {

    my $result =  await $self->load_p(
        $companies_pkey, $users_pkey
    );

    return $result->{languages_fkey};
}

1;