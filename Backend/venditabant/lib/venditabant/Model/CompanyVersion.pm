package venditabant::Model::CompanyVersion;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub get_version($self, $companies_pkey) {

    my $company_version_stmt = qq {
        SELECT MAX(version) as version
            FROM company_version
        WHERE companies_fkey = ?
    };

    my $version = $self->db->query(
        $company_version_stmt,
            ($companies_pkey)
    )->hash->{version};

    return $version;
}

async sub set_version ($self, $companies_fkey, $version) {

    my $stmt = qq {
        INSERT INTO company_version (companies_fkey, version)
            VALUES (?,?)
        ON CONFLICT (companies_fkey)
            DO UPDATE SET version = ?, moddatetime = now()
        RETURNING company_version_pkey
    };

    my $company_version_pkey = $self->db->query(
        $stmt,($companies_fkey, $version, $version)
    )->hash->{company_version_pkey};

    return $company_version_pkey > 0;
}
1;