package Workflows::Helper::Export;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Mojo::File;

use Workflows::Model::Workflows;
use Workflows::Model::WorkflowItems;

has 'pg';

async sub export($self) {

    my $stmt = '';

    my $workflows = await Workflows::Model::Workflows->new(
        db => $self->pg->db
    )->load_list(0,0);

    my $wf_items = Workflows::Model::WorkflowItems->new(db => $self->pg->db);
    foreach my $workflow (@{$workflows}) {
        $stmt .= await $self->generate_wfl_upsert($workflow->{workflow});
        my $items = await $wf_items->load_workflow_items($workflow->{workflows_pkey});
        foreach my $item (@{$items}) {
            $stmt .= await $self->generate_wfl_upsert_item($workflow->{workflow}, $item);
        }
    }

    return $stmt;
}

async sub generate_wfl_upsert_item($self, $workflow, $item) {

    my $workflow_type = $item->{workflow_type};
    my $workflow_data = $item->{workflow};
    return qq{
        INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
        VALUES (
            (SELECT workflows_pkey FROM workflows WHERE workflow = '$workflow'),
            '$workflow_type', '$workflow_data'
        )
        ON CONFLICT( workflows_fkey, workflow_type)
        DO UPDATE SET moddatetime = now(), workflow = '$workflow_data' ;
    };
}

async sub generate_wfl_upsert($self, $wfl) {

    return qq{
        INSERT INTO workflows (workflow) VALUES ('$wfl')
            ON CONFLICT (workflow)
        DO UPDATE SET moddatetime = now();
    };

}
1;