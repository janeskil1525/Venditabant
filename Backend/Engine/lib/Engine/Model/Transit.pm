package Engine::Model::Transit;
use Mojo::Base -base, -signatures, -async_await;

has 'db';

sub insert($self, $data) {

    my $users = '';
    if (exists  $data->{users_pkey}) {
        $users = qq{
            (SELECT userid FROM users WHERE users_pkey = $data->{users_pkey}),
                    (SELECT userid FROM users WHERE users_pkey = $data->{users_pkey}),
        };
    } else {
        $users = "'System', 'System',"
    }
    my $stmt = qq{
        INSERT INTO transit (insby, modby, type, activity, payload, status, workflow)
            VALUES ($users ?,?,?,?,?)
        RETURNING transit_pkey
    };
    my $transit_pkey;
    eval {
        $transit_pkey = $self->db->query(
            $stmt,(
                $data->{type},
                $data->{activity},
                $data->{payload},
                $data->{status},
                $data->{workflow},
            )
        )->hash->{transit_pkey};
    };
    say $@ if $@;

    return $transit_pkey;
}

sub load_transits($self, $type, $status) {

    my $result = $self->db->select(
        'transit',
        ['*'],
            {
                type => $type,
                status   => $status,
            }
    );

    my $hash;
    $hash = $result->hashes if $result and $result->rows > 0;

    return $hash;
}

sub set_status($self, $transit_pkey, $status) {

    $self->db->update(
        'transit',
            {
                status      => $status,
                moddatetime => 'now()',
                'editnum'     => 'editnum' + 1,
            },
            {
                transit_pkey => $transit_pkey
            }
    );

    return 1;
}
1;