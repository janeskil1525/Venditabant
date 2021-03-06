package Release::Helpers::Release::ReleaseStep_0;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures;

has 'db';

sub step ($self, $companies_pkey) {

    my $stmt = qq {
        INSERT INTO pricelists (pricelist, companies_fkey)
            VALUES ('DEFAULT',?)
        ON CONFLICT (pricelist, companies_fkey)
        DO UPDATE SET moddatetime = now();
    };

    $self->db->query($stmt,($companies_pkey));
}
1;