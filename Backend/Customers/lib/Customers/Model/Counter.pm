package Customers::Model::Counter;
use Mojo::Base -base, -signatures, -async_await;


has 'db';

sub nextid ($self, $company_fkey, $users_pkey, $name) {

    my $counter_stmt = qq {
        INSERT INTO counter (insby, modby, name, counter, companies_fkey)
        VALUES (
        (SELECT userid FROM users WHERE users_pkey = ?),
        (SELECT userid FROM users WHERE users_pkey = ?),?,1,?)
            ON CONFLICT (name, companies_fkey)
        DO UPDATE SET counter = counter.counter + 1,
                        modby = (SELECT userid FROM users WHERE users_pkey = ?)
            RETURNING counter
    };

    my $nextid = $self->db->query(
        $counter_stmt,
            (
                $users_pkey,
                $users_pkey,
                $name,
                $company_fkey,
                $users_pkey
            )
    )->hash->{counter};

    return $nextid;
}
1;