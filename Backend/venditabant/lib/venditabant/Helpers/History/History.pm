package venditabant::Helpers::History::History;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use venditabant::Model::History::List;
use Data::Dumper;

has 'pg';

async sub load_list ($self, $companies_pkey, $hist_type, $hist_key) {

    my $result;
    my $err;

    eval {
        my $history = venditabant::Model::History::List->new(
            db => $self->pg->db
        );

        $result = $history->load_users_list(
            $companies_pkey, $hist_key
        ) if $hist_type eq 'users';

    };
    $err = $@ if $@;
    $self->capture_message(
        $self->pg, '',
        'venditabant::Helpers::History::History', 'load_list', $err
    ) if $err;

    return $result;
}
1;