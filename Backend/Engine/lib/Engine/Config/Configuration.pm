package Engine::Config::Configuration;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Workflow::Config;
use XML::Simple qw(:strict);

has 'pg';

my %XML_OPTIONS = (
    mappings => {
        ForceArray => [],
        KeyAttr => [],
    },
    precheck => {
        ForceArray =>
            [ 'action', 'field', 'groups'],
        KeyAttr => [],
    },
    auto_transit => {
        ForceArray =>
            [ 'transits'],
        KeyAttr => [],
    },
    action => {
        ForceArray =>
            [ 'action', 'field', 'source_list', 'param', 'validator', 'arg' ],
        KeyAttr => [],
    },
    condition => {
        ForceArray => [ 'condition', 'param' ],
        KeyAttr    => [],
    },
    persister => {
        ForceArray => ['persister'],
        KeyAttr    => [],
    },
    validator => {
        ForceArray => [ 'validator', 'param' ],
        KeyAttr    => [],
    },
    workflow => {
        ForceArray => [
            'extra_data', 'stat$conf->{workflow_type}e',
            'action',     'resulting_state',
            'condition',  'observer'
        ],
        KeyAttr => [],
    },
);

async sub load_config($self, $workflow, $items) {

    my $config = await $self->_load_config($workflow, $items);
    my %temp;
    my $hash = \%temp;

    foreach my $conf (@{ $config }) {
        my $options = $XML_OPTIONS{$conf->{workflow_type}} || {};
        $hash->{$conf->{workflow_type}} = XMLin($conf->{workflow}, %{$options});
        if($conf->{workflow_type} eq 'persister') {
            $hash->{$conf->{workflow_type}} = $hash->{$conf->{workflow_type}}->{persister};
        }
    }

    return $hash;
}

async sub _load_config($self, $workflow, $items) {

   my $stmt = qq{
        SELECT workflow_type, workflow_items.workflow as workflow
            FROM workflows, workflow_items
        WHERE workflows_fkey = workflows_pkey AND workflows.workflow = ? AND
        workflow_type IN $items
   };

    my $result = $self->pg->db->query($stmt,($workflow));

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}

sub get_actions($self) {

    my $config = $self->_get_actions( );
    my %temp;
    my $hash = \%temp;

    foreach my $conf (@{ $config }) {
        my $options = $XML_OPTIONS{'action'} || {};
        my $action = XMLin($conf->{workflow}, %{$options});
        push @{$hash->{'actions'}}, $action;
    }

    return $hash;
}

sub _get_actions($self) {

    my $stmt = qq{
        SELECT workflow_items.workflow as workflow
            FROM  workflow_items
        WHERE workflow_type = 'action'
   };

    my $result = $self->pg->db->query($stmt);

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash
}
1;