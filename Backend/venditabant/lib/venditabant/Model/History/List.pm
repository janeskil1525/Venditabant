package venditabant::Model::History::List;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'db';

async sub load_users_list ($self, $companies_pkey, $users_fkey) {

    my $stmt = qq{
        SELECT action, description, state, workflow_user, history_date
            FROM workflow_companies as a JOIN workflow_history as b ON a.workflow_id = b.workflow_id
        WHERE a.companies_fkey = ? and users_fkey = ?
    };

    my $result = await $self->db->query_p(
        $stmt,
        (
            $companies_pkey, $users_fkey
        )
    );

    my $hash;
    $hash = $result->hashes if $result->rows;
    return $hash;
}
1;