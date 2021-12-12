package Engine::Config::Configuration;
use Mojo::Base -base, -signatures, -async_await;

use Workflow::Factory qw(FACTORY);
use Data::Dumper;
use Workflow::Config;
use XML::Hash::XS;

has 'pg';

async sub load_config($self, $workflow) {

    my $result;
    my $config = await $self->_load_config($workflow);
    my %temp;
    my $hash = \%temp;

    foreach my $conf (@{ $config }) {
        my %string_hash = eval ($conf->{workflow});
        say  $@ if $@;
        $hash->{$conf->{workflow_type}} = \%string_hash;
    }

    # foreach my $conf (@{ $config }) {
    #     $hash->{$conf->{workflow_type}} =  XML::Hash::XS
    #         ->new(utf8 => 0, encoding => 'utf-8')  # , use_attr => 1
    #         ->xml2hash($conf->{workflow}, encoding => 'cp1251');
    # }

    # await $self->_init_factory($hash);
    return $hash;
}



async sub _load_config($self, $workflow) {

   my $stmt = qq{
        SELECT workflow_type, workflow_items.workflow as workflow
            FROM workflows, workflow_items
        WHERE workflows_fkey = workflows_pkey AND workflows.workflow = ?
   };

    my $result = $self->pg->db->query($stmt,($workflow));

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}
1;