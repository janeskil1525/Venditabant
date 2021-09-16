package venditabant::Controller::Users;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Try::Tiny;
use Data::UUID;
use Data::Dumper;
use Digest::SHA qw{sha512_base64};

has 'pg';

sub signup_user{
    my($self, $user) = @_;

    my $stmt;
    my $result;
    delete $user->{password} unless $user->{password};

    say Dumper($user);
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
    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );
    my $json_hash = from_json ($self->req->body);
    $self->users->upsert($companies_pkey, $json_hash)->then(sub ($result) {
        $self->render(json => {'result' => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => $err});
    })->wait;
}

sub load_list ($self) {

    $self->render_later;
    my $companies_pkey = $self->jwt->companise_pkey(
        $self->req->headers->header('X-Token-Check')
    );
say Dumper($self->users);
    $self->users->load_list($companies_pkey)->then(sub ($result) {

        $self->render(json => {'result' => 'success', data => $result});
    })->catch( sub ($err) {

        $self->render(json => {'result' => 'failed', data => $err});
    })->wait;
}
1;