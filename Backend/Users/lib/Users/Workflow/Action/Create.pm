package Users::Workflow::Action::Create;
use Mojo::Base 'Engine::Workflow::Action::Base',-base, -signatures;

use Data::Dumper;
use Users::Model::Users;
use Digest::SHA qw{sha512_base64};

sub execute ($self, $wf) {

    $self->_init($wf,'UsersPersister');

    my $companies_fkey = $self->context->param('companies_fkey');
    my $saving_user_pkey = $self->context->param('users_pkey');
    $saving_user_pkey = 0 unless $saving_user_pkey;
    my $user = $self->data->{userid};
    my $err;
    my $users_pkey = 0;

    eval {
        $self->data->{password} = sha512_base64($self->data->{password});
        if ($saving_user_pkey > 0) {
            $users_pkey = $self->insert($wf, $self->data);
        } else {
            $users_pkey = $self->signup($wf, $self->data);
        }

        $self->upsert_user_companies(
            $companies_fkey, $users_pkey
        );

        $self->set_workflow_relation($companies_fkey, $users_pkey, $self->workflow, $wf->id, $users_pkey);

        if ($saving_user_pkey > 0) {
            $self->add_history($wf, "New user created", "User $user was created",$self->context->param('history')->{userid});
        } else {
            $self->add_history($wf, "New user created", "User $user was created",$self->context->param('history')->{userid});
        }

        $self->tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message($@, (caller(0))[1], (caller(0))[0], (caller(0))[3]) if $@;;

    return $err ? $err : 'success';
}

sub insert($self, $wf, $data) {

    $self->add_history($wf,"New user","User $data->{userid} will be created",$self->context->param('history')->{userid},);

    my $users_stmt = qq{
        INSERT INTO users (userid, username, passwd, active, languages_fkey) VALUES (?,?,?,?, ?)
            ON CONFLICT (userid)
            DO UPDATE SET moddatetime = now(), username = ?, passwd = ?, active = ?, languages_fkey = ?
        RETURNING users_pkey
    };

    my $users_pkey = $self->db->query(
        $users_stmt,
        (
            $data->{userid},
            $data->{username},
            $data->{password},
            $data->{active},
            $data->{languages_fkey},
            $data->{username},
            $data->{password},
            $data->{active},
            $data->{languages_fkey},
        )
    )->hash->{users_pkey};

    return $users_pkey;
}

sub upsert_user_companies ($self, $companies_pkey, $users_pkey) {

    my $users_stmt = qq {
        INSERT INTO users_companies (companies_fkey, users_fkey) VALUES (?,?)
            ON CONFLICT (companies_fkey, users_fkey)
            DO UPDATE SET moddatetime = now()
        RETURNING users_companies_pkey;
    };

    my $users_companies_pkey = $self->db->query(
        $users_stmt,
        (
            $companies_pkey,
            $users_pkey
        )
    )->hash->{users_companies_pkey};

    return $users_companies_pkey;
}

sub signup($self, $wf, $data) {

    $self->add_history($wf, "New user", "User $data->{userid} will be created",'Signup');

    my $users_stmt = qq {
        INSERT INTO users (userid, username, passwd, languages_fkey)
        VALUES (?,?,?, (SELECT languages_pkey FROM languages WHERE lan = 'swe'))
        RETURNING users_pkey;
    };

    my $users_pkey = $self->db->query(
        $users_stmt,
        ($data->{userid}, $data->{username}, $data->{password})
    )->hash->{users_pkey};

    return $users_pkey
}
1;