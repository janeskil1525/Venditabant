package Engine::Model::Transit;
use Mojo::Base -base, -signatures, -async_await;

has 'db';

sub insert($self, $data) {

    my $stmt = qq{
        INSERT INTO transit(insby, modby, type, activity, payload, status)
            VALUES ((SELECT userid FROM users WHERE users_pkey = ?),
                    (SELECT userid FROM users WHERE users_pkey = ?), ?,?,?,?)
        RETURNING transit_pkey
    };
    my $transit_pkey = $self->db->query(
        $stmt, {
            $data->{users_pkey},
            $data->{users_pkey},
            $data->{type},
            $data->{activity},
            $data->{payload},
            $data->{status},
        }
    )->hash->{transit_pkey};

    return $transit_pkey;
}
1;