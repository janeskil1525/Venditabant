package Mailer::Model::Workflow;
use Mojo::Base -base, -signatures;

use Data::Dumper;

has 'db';

sub insert($self, $workflow_id, $mailer_mails_fkey) {

    $self->db->insert(
        'workflow_invoice',
            {
                workflow_id         => $workflow_id,
                mailer_mails_fkey   => $mailer_mails_fkey,
            }
    );
}

sub load_workflow_id($self, $mailer_mails_fkey {

    my $result = $self->db->select(
        'workflow_mail',['workflow_id'],
            {
                mailer_mails_fkey => $mailer_mails_fkey,
            }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;

    return $hash->{workflow_id};
}

sub load_workflow_list ($self) {

    my $result = $self->db->select(
        'workflow_mail',
            ['*'],
            {
                semt => 'false',
            }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows;

    return $hash;
}
1;