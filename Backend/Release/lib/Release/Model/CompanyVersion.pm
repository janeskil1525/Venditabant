package Release::Model::CompanyVersion;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures;

use Data::Dumper;

has 'db';

sub get_version($self, $companies_pkey) {

    my $company_version_stmt = qq {
        SELECT MAX(version) as version
            FROM company_version
        WHERE companies_fkey = ?
    };

    my $result = $self->db->query(
        $company_version_stmt,
            ($companies_pkey)
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash->{version} ? $hash->{version} : 0;
}

sub set_version ($self, $companies_fkey, $version) {

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