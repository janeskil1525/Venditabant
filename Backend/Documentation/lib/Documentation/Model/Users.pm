package Documentation::Model::Users;
use Mojo::Base -base, -signatures;

use Digest::SHA qw{sha512_base64};

has 'pg';

sub login {
    my ($self, $user, $password) = @_;

    $password = '' unless $password;
    my $passwd = sha512_base64($password);
    my $result = $self->pg->db->query("select * from users where userid = ? and passwd= ?",($user,$passwd));
    return $result->rows() > 0;

    #return Daje::Model::User->new(pg => $self->pg)->login_light($user, $password);
}

sub save {
    my ($self, $user) = @_;

    return $self->pg->db->query(qq{
		INSERT INTO users(
			userid, username, passwd)
			VALUES (?, ?, ?)
				ON CONFLICT (userid)
			DO UPDATE
				SET moddatetime = now(),
				editnum = users.editnum + 1,
				username = ?,
				passwd = ?;
	},(
        $user->{userid}, $user->{username}, $user->{passwd}, $user->{username}, $user->{passwd}
    )
    );
}

sub save_p ($self, $user) {

    return $self->pg->db->insert_p(
        'users',
        $user,
        {on_conflict => undef}
    );
}

sub list_p {
    my $self = shift;

    return $self->pg->db->select_p('users');
}

1;