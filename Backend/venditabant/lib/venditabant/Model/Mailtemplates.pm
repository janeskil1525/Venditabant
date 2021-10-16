package venditabant::Model::Mailtemplates;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';


sub load_list ($self) {
    my $result = $self->db->select(
        'mailer', '*',undef,
        {
             order_by => 'mailtemplate',
        }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}

1;