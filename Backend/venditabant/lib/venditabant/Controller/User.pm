package venditabant::Controller::User;
use Mojo::Base 'Daje::Utils::Sentinelsender';

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
            $self->capture_message("[Daje::Model::User::save_user with no password] " . $_);
        }
    }

    return $result;
}

1;