package venditabant::Helpers::Companies::Release::ReleaseStep_2;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub step ($self, $companies_pkey) {

    my $stmt = qq {
        INSERT INTO parameters (parameter, description, companies_fkey)
            VALUES ('PRODUCTGROUPS','Product groups',?)
        ON CONFLICT (parameter, companies_fkey)
            DO UPDATE SET moddatetime = now()
        RETURNING parameters_pkey;
    };

    my $parameters_pkey = $self->db->query(
        $stmt,($companies_pkey)
    )->hash->{parameters_pkey};

    $stmt = qq {
        INSERT INTO parameters_items (parameters_fkey, param_value, param_description)
        VALUES (?, 'Ingredients', 'Ingredients'),
                (?, 'Accessories', 'Accessories'),
                (?, 'Machines', 'Machines'),
                (?, 'Service', 'Service'),
                (?, 'Transport', 'Transport')
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