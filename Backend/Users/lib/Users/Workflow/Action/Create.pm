package Users::Workflow::Action::Create;
use strict;
use warnings FATAL => 'all';
use base qw( Engine::Workflow::Action::Base );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::History;


use Sentinel::Helpers::Sentinelsender;
use Users::Model::Users;
use Sentinel::Helpers::Sentinelsender;

sub execute ($self, $wf) {

    $self->_init($wf,'UsersPersister');

    my $companies_pkey = $self->context->param('companies_fkey');
    my $saving_user_pkey = $self->context->param('users_pkey');
    $saving_user_pkey = 0 unless $saving_user_pkey;
    my $user = $self->data->{userid};
    my $err;

    eval {
        my $users_pkey = 0;
        my $user_obj = Users::Model::Users->new(db => $self->db);
        if ($saving_user_pkey > 0) {
            $self->add_history($wf,"New user","User $user will be created",$self->context->param('history')->{userid},);

            $users_pkey = $user_obj->insert(
                $user, $saving_user_pkey
            );
            my $users_companies_pkey = $user_obj->upsert_user_companies(
                $companies_pkey, $users_pkey
            );
        } else {
            $users_pkey = $user_obj->signup($data);
            $self->add_history($wf, "New user", "User $user will be created",'Signup');

            $user_obj->upsert_user_companies(
                $data->{companies_fkey}, $users_pkey
            );
        }

        $self->set_workflow_relation($companies_fkey, $users_pkey, $workflow, $wf->id, $users_pkey);

        $self->tx->commit();
        
        if ($saving_user_pkey > 0) {
            $self->add_history($wf, "New user created", "User $user was created",$self->context->param('history')->{userid});
        } else {
            $self->add_history($wf, "New user created", "User $user was created",$self->context->param('history')->{userid});
        }
    };
    $err = $@ if $@;
    $self->capture_message($@, (caller(0))[1], (caller(0))[0], (caller(0))[3]) if $@;;

    return $err ? $err : 'success';
}


1;