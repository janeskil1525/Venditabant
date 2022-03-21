package Mailer::Model::Workflow;
use Mojo::Base -base, -signatures;

use Data::Dumper;

has 'db';

sub insert($self, $workflow_id, $mailer_mails_fkey, $companies_fkey) {

    my $err;
    eval {
        $self->db->insert(
            'workflow_mail',
            {
                workflow_id        => $workflow_id,
                mailer_mails_fkeys => $mailer_mails_fkey,
                companies_fkey     => $companies_fkey,
            }
        );
    };
    $err = $@ if $@;

    return '1' unless $err;
    return $err;
}

sub load_workflow($self, $workflow_id) {

    my $result = $self->db->select(
        'workflow_mail',['*'],
        {
            workflow_id => $workflow_id,
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows;

    return $hash;
}

sub load_workflow_id($self, $mailer_mails_fkey) {

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
                sent => 0,
            }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows;

    return $hash;
}

sub set_workflow_status ($self, $id, $status) {

    $self->db->update(
        'workflow_mail',
            {
                sent        => $status,
            },
            {
                workflow_id => $id,
            }

    );

    return 1;
}
1;