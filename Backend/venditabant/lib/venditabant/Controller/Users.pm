package venditabant::Controller::Users;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Try::Tiny;
use Data::UUID;
use Data::Dumper;
use Digest::SHA qw{sha512_base64};
use Mojo::JSON qw {decode_json};

has 'pg';

sub signup_user{
    my($self, $user) = @_;

    my $stmt;
    my $result;
    delete $user->{password} unless $user->{password};

    if (exists $user->{password}){
        $user->{passwd} = sha512_base64($user->{password});
        $stmt = qq{INSERT INTO users (username, userid, active, passwd) VALUES (?,?,?,?,?)
                    ON CONFLICT (userid) DO UPDATE SET username = ?,
                    passwd = ?, moddatetime = now(), active = ?
                        RETURNING users_pkey};

        $result = try {
            $self->pg->db->query($stmt,(
                $user->{username},
                $user->{userid},
                $user->{active},
                $user->{passwd},
                $user->{username},
                $user->{passwd},
                $user->{active}
            ));
        }catch{
            $self->capture_message("[Daje::Model::User::save_user with password] " . $_);
        };
    }else{
        $stmt = qq{UPDATE users SET username = ?,
                        moddatetime = now(), active = ? WHERE userid = ?
                    RETURNING users_pkey};

        $result = try{
            $self->pg->db->query($stmt,(
                $user->{username},
                $user->{active},
                $user->{userid},
            ));
        }catch{
            #$self->capture_message("[Daje::Model::User::save_user with no password] " . $_);
        }
    }

    return $result;
}

sub save_user ($self) {

    $self->render_later;
    my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $data->{user} = decode_json ($self->req->body);
    $data->{users_fkey} = $users_pkey;
    $data->{companies_fkey} = $companies_pkey;

    $data->{workflow_id} = Companies->new(
        pg => $self->app->pg
    )->load_workflow_id(
        $companies_pkey
    );

    if(exists $data->{user}->{users_pkey} and $data->{user}->{users_pkey} > 0) {
        push @{$data->{actions}}, 'update_user';
    } else {
        push @{$data->{actions}}, 'create_user';
    }
say Dumper($data);
    eval {
        $self->workflow->execute(
            'companies', $data
        );
        $self->render(json => { result => 'success'});
    };

    $self->render(json => { result => 'failure', error => $@}) if $@;
}

sub load_list ($self) {

    $self->render_later;
    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    $self->users->load_list($companies_pkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}

sub load_list_support ($self) {

    $self->render_later;
    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    $self->users->load_list_support()->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}
1;