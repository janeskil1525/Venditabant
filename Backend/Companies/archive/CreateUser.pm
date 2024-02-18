package Companies::Workflow::Action::CreateUser;
use strict;
use warnings FATAL => 'all';
use base qw( Engine::Workflow::Action::Base );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::History;
use Workflow::Exception qw( workflow_error );

use Sentinel::Helpers::Sentinelsender;
use Companies::Model::Workflow;

sub execute ($self, $wf) {

    my $pg = $self->get_pg('CompaniesPersister');
    my $context = $wf->context;

    my $data = $context->param('user');
    my $companies_pkey = $context->param('companies_pkey');
    my $saving_user_pkey = $context->param('users_pkey');

    my $user = $data->{userid};
    my $db = $pg->db;
    my $tx = $db->begin();
    my $err;

    eval {
        $wf->add_history(
            Workflow::History->new({
                action      => "New user",
                description => "User $user will be created",
                user        => $context->param('history')->{userid},
            })
        );

        my $user_obj = Companies::Model::Users->new(db => $db);
        my $users_pkey = $user_obj->insert(
            $user, $saving_user_pkey
        );

        my $users_companies_pkey = $user_obj->upsert_user_companies(
            $companies_pkey, $users_pkey
        );

        Companies::Model::Workflow->new(
            db => $db
        )->insert(
            $wf->id, $users_pkey, $companies_fkey
        );

        $tx->commit();

        my $result = $self->insert($wf, $pg, $companies_fkey, $data);

        $wf->add_history(
            Workflow::History->new({
                action      => "New user created",
                description => "User $user was created",
                user        => $context->param('history')->{userid},
            })
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;

    workflow_error($err) if $err;

    return $err ? $err : 'success';
}

sub insert ($self, $wf, $pg, $companies_pkey, $user) {

    my $db = $pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $user_obj = Companies::Model::Users->new(db => $db);
        my $users_pkey = $user_obj->insert(
            $user
        );

        my $users_companies_pkey = $user_obj->upsert_user_companies(
            $companies_pkey, $users_pkey
        );

        Companies::Model::Workflow->new(
            db => $db
        )->insert(
            $wf->id, $users_pkey, $companies_fkey
        );

        $tx->commit();
    };

    $err = $@ if $@;
    $self->capture_message (
        $pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;

    workflow_error($err) if $err;

    return $err ? $err : 'success';
}
1;