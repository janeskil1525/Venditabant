package venditabant::Helpers::Companies::Release::ReleaseStep_4;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub step ($self, $companies_pkey) {

    my $stmt = qq {
        INSERT INTO companies (companies_pkey, languages_fkey)
            VALUES (0, (SELECT languages_pkey FROM languages WHERE lan = 'swe'))
        ON CONFLICT (companies_pkey)
            DO UPDATE SET moddatetime = now();
    };

    $self->db->query(
        $stmt
    );

    $stmt = qq {
        INSERT INTO parameters (parameter, description, companies_fkey)
            VALUES ('EMPTY','Zero param',0)
        ON CONFLICT (parameter, companies_fkey)
            DO UPDATE SET moddatetime = now()
        RETURNING parameters_pkey;
    };

    my $parameters_pkey = $self->db->query(
        $stmt
    )->hash->{parameters_pkey};

    $stmt = qq {
        INSERT INTO parameters_items (parameters_items_pkey, parameters_fkey, param_value, param_description)
        VALUES (0, ?, '', '')
        ON CONFLICT (parameters_fkey, param_value)
            DO UPDATE SET moddatetime = now();
    };
    $self->db->query(
        $stmt,($parameters_pkey)
    );
}


1;