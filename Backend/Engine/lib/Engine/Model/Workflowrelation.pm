package Engine::Model::Workflowrelation;
use Mojo::Base -base, -signatures;

has 'db';

sub load($self, $workflow, $key_value) {

    my $result = $self->db->select(
        $workflow->{workflow_relation} ,
            ['workflow_id'],
            {
                $workflow->{workflow_relation_key} => $key_value
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash;
}

sub insert($self, $companies_fkey, $users_fkey, $workflow, $workflow_id, $key_value) {

    my $result = 0;
    $result = $self->_insert( $companies_fkey, $users_fkey, $workflow, $workflow_id,$key_value)
        unless $workflow->{workflow_relation} eq 'workflow_companies'
            or $workflow->{workflow_relation} eq 'workflow_users';

    $result = $self->_insert_company( $companies_fkey, $workflow, $workflow_id, $key_value)
        unless $workflow->{workflow_relation} eq 'workflow_users' or $result == 1;

    $result = $self->_insert_user( $companies_fkey, $users_fkey, $workflow, $workflow_id,$key_value)
        unless $result == 1;
}

sub _insert_company($self, $companies_fkey, $workflow, $workflow_id, $key_value) {
    $self->db->insert($workflow->{workflow_relation},
        {
            companies_fkey     => $key_value,
            workflow_id        => $workflow_id,
        }
    );

    return 1;
}

sub _insert_user($self, $companies_fkey, $users_fkey, $workflow, $workflow_id, $key_value) {
    $self->db->insert($workflow->{workflow_relation},
        {
            users_fkey         => $key_value,
            customers_fkey     => $companies_fkey,
            workflow_id        => $workflow_id,
            creating_user_fkey => $users_fkey,
        }
    );
    return 1;
}
sub _insert($self, $companies_fkey, $users_fkey, $workflow, $workflow_id, $key_value) {
    $self->db->insert($workflow->{workflow_relation},
        {
            $workflow->{workflow_relation_key} => $key_value,
            customers_fkey                     => $companies_fkey,
            users_fkey                         => $users_fkey,
            workflow_id                        => $workflow_id,
        }
    );
    return 1;
}
1;