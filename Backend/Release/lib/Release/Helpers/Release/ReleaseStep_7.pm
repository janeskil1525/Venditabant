package Release::Helpers::Release::ReleaseStep_7;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures;

use Data::Dumper;

has 'db';

sub step ($self, $companies_pkey) {

    my $stmt = qq{
        INSERT INTO parameters (parameter, description, companies_fkey)
            VALUES ('SALESUNITS','Sales units',?)
        ON CONFLICT (parameter, companies_fkey)
            DO UPDATE SET moddatetime = now()
        RETURNING parameters_pkey;
    };

    my $parameters_pkey = $self->db->query(
        $stmt, ($companies_pkey)
    )->hash->{parameters_pkey};

    $stmt = qq{
        INSERT INTO parameters_items (parameters_fkey, param_value, param_description)
        VALUES (?, 'St', 'Styck'),
                (?, 'l', 'Liter')
        ON CONFLICT (parameters_fkey, param_value)
            DO UPDATE SET moddatetime = now();
    };
    $self->db->query(
        $stmt, ($parameters_pkey, $parameters_pkey)
    );
}
1;