package venditabant::Helpers::Workflow::Config;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'pg';

async sub load_config($self, $workflow) {

    my $result;
    my $config = await $self->_load_config($workflow);
    foreach my $conf (@{ $config }) {
        $result->{$conf->{workflow_type}} = $conf->{workflow};
    }

    return $result;
}

async sub _load_config($self, $workflow) {

   my $stmt = qq{
        SELECT workflow_type, workflow_items.workflow as workflow
            FROM workflows, workflow_items
        WHERE workflows_fkey = workflows_pkey AND workflow = ?
   };

    my $result = $self->pg->db->query($stmt,($workflow));

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}
1;