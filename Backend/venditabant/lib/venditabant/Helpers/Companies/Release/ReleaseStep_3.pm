package venditabant::Helpers::Companies::Release::ReleaseStep_3;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub step ($self, $companies_pkey) {

    my $stmt = qq {
        INSERT INTO parameters (parameter, description, companies_fkey)
            VALUES ('INVOICEDAYS','Invouice days',?)
        ON CONFLICT (parameter, companies_fkey)
            DO UPDATE SET moddatetime = now()
        RETURNING parameters_pkey;
    };

    my $parameters_pkey = $self->db->query(
        $stmt,($companies_pkey)
    )->hash->{parameters_pkey};

    $stmt = qq {
        INSERT INTO parameters_items (parameters_fkey, param_value, param_description)
        VALUES (?, '30', 'Days'),
                (?, '20', 'Days'),
                (?, '15', 'Days'),
                (?, '10', 'Days'),
                (?, '0', 'Cash')
        ON CONFLICT (parameters_fkey, param_value)
            DO UPDATE SET moddatetime = now();
    };
    $self->db->query(
        $stmt,(
            $parameters_pkey,
            $parameters_pkey,
            $parameters_pkey,
            $parameters_pkey,
            $parameters_pkey
        )
    );

}


1;