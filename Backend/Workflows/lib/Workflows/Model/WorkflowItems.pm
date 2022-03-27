package Workflows::Model::WorkflowItems;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'db';

sub upsert ($self, $companies_pkey, $users_pkey, $workflow) {

    my $stmt = qq{
        INSERT INTO workflow_items (insby, modby, workflows_fkey, workflow_type, workflow)
            VALUES ((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?),?,?,?)
            ON CONFLICT (workflows_fkey, workflow_type)
        DO UPDATE SET workflow = ?,
            moddatetime = now(),
            modby = (SELECT userid FROM users WHERE users_pkey = ?)
        RETURNING workflow_items_pkey
    };

    my $customers_pkey = $self->db->query(
        $stmt,
        (
            $users_pkey,
            $users_pkey,
            $workflow->{workflows_fkey},
            $workflow->{workflow_type},
            $workflow->{workflow},
            $workflow->{workflow},
            $users_pkey,
        )
    )->hash->{warehouses_pkey};

    return $customers_pkey;
}

async sub load_workflow($self, $companies_pkey, $users_pkey, $workflows_fkey, $workflow_type) {

    my $result;

    eval {
        $result =  $self->db->select(
            'workflow_items',
            ['*'],
            {
                workflows_fkey => $workflows_fkey,
                workflow_type  => $workflow_type
            }
        );
    };
    say $@ if $@;

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}

async sub load_workflow_items($self,  $workflows_fkey ) {

    my $result;

    eval {
        $result =  $self->db->select(
            'workflow_items',
            ['*'],
            {
                workflows_fkey => $workflows_fkey,
            }
        );
    };
    say $@ if $@;

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}
1;