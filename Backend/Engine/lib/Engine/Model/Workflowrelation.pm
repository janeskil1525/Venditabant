package Engine::Model::Workflowrelation;
use Mojo::Base -base, -signatures;

has 'db';

sub load($self, $table, $key_name, $key_value) {

    my $result = $self->db->select($table,['workflow_id'],{$key_name => $key_value});

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}

sub insert($self, $companies_fkey, $users_fkey, $workflow, $workflow_id) {

    my $result = 0;
    $result = $self->_insert( $companies_fkey, $users_fkey, $workflow, $workflow_id)
        unless $workflow->{workflow_relation} eq 'workflow_company'
            or $workflow->{workflow_relation} eq 'workflow_users';

    $self->_insert_company( $companies_fkey, $workflow, $workflow_id)
        unless $workflow->{workflow_relation} eq 'workflow_users' or $result == 1;

    $self->_insert_user( $companies_fkey, $users_fkey, $workflow, $workflow_id)
        unless $result == 1;
}

sub _insert_company($self, $companies_fkey, $users_fkey, $workflow, $workflow_id) {
    $self->insert($workflow->{workflow_relation},
        {
            $key_name      => $key_value,
            customers_fkey => $companies_fkey,
            workflow_id    => $workflow_id,
            users
        }
    );
}

sub _insert_user($self, $companies_fkey, $users_fkey, $workflow, $workflow_id) {
    $self->insert($workflow->{workflow_relation},
        {
            $key_name      => $key_value,
            customers_fkey => $companies_fkey,
            workflow_id    => $workflow_id,
        }
    );
}
sub _insert($self, $companies_fkey, $users_fkey, $workflow, $workflow_id) {
    $self->insert($workflow->{workflow_relation},
        {
            $key_name      => $key_value,
            customers_fkey => $companies_fkey,
            users_fkey     => $users_fkey,
            workflow_id    => $workflow_id,
        }
    );
}
1;