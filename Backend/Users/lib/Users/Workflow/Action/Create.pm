package Users::Workflow::Action::Create;
use strict;
use warnings FATAL => 'all';
use base qw( Engine::Workflow::Action::Base );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::History;
use Workflow::Exception qw( workflow_error );

use Sentinel::Helpers::Sentinelsender;
use Users::Model::Workflow;

sub execute ($self, $wf) {

    my $pg = $self->get_pg('UsersPersister');
    my $context = $wf->context;

    my $data = $context->param('user');
    my $companies_pkey = $context->param('companies_fkey');
    my $saving_user_pkey = $context->param('users_pkey');

    my $user = $data->{userid};
    my $db = $pg->db;
    my $tx = $db->begin();
    my $err;

    eval {
        my $users_pkey = 0;
        my $user_obj = Users::Model::Users->new(db => $db);
        if ($saving_user_pkey > 0) {
            $wf->add_history(
                Workflow::History->new({
                    action      => "New user",
                    description => "User $user will be created",
                    user        => $context->param('history')->{userid},
                })
            );
            $users_pkey = $user_obj->insert(
                $user, $saving_user_pkey
            );
        } else {
            $users_pkey = $user_obj->signup($user);
            $wf->add_history(
                Workflow::History->new({
                    action      => "New user",
                    description => "User $user will be created",
                    user        => 'Signup',
                })
            );
        }

        my $users_companies_pkey = $user_obj->upsert_user_companies(
            $companies_pkey, $users_pkey
        );

        Users::Model::Workflow->new(
            db => $db
        )->insert(
            $wf->id, $users_pkey
        );

        $tx->commit();
        
        if ($saving_user_pkey > 0) {
            $wf->add_history(
                Workflow::History->new({
                    action      => "New user created",
                    description => "User $user was created",
                    user        => $context->param('history')->{userid},
                })
            );
        } else {
            $wf->add_history(
                Workflow::History->new({
                    action      => "New user created",
                    description => "User $user was created",
                    user        => 'Signup',
                })
            );
        }

    };
    $err = $@ if $@;
    $self->capture_message (
        $pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;

    return $err ? $err : 'success';
}


1;