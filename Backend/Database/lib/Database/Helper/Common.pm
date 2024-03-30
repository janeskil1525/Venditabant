package Database::Helper::Common;
use Mojo::Base  -base, -signatures, -async_await;

use List::MoreUtils qw { first_index };
use Mojo::JSON qw { decode_json};

has 'app';

sub get_basedata($self) {

    my ($companies_pkey, $users_pkey) = $self->app->jwt->companies_users_pkey(
        $self->app->req->headers->header('X-Token-Check')
    );

    my $data->{data} = decode_json ($self->app->req->body)
        if $self->app->req->body;
    $data->{users_fkey} = $users_pkey;
    $data->{companies_fkey} = $companies_pkey;

    my $table = $self->app->param('table');
    $data = $self->_find_keys($table, $data);

    return $data;
}

sub _find_keys($self, $table, $data) {
    my @keys = ();
    my $index = 0;
    my $err;
    eval {
        my $method = $table->{methods};
        $index = first_index { 'list' eq $_->{action}} @{$method};

        if (exists $table->{methods}[$index]->{foreign_key} and $table->{methods}[$index]->{foreign_key}) {
            push(@keys, $table->{methods}[$index]->{foreign_key});
        } else {
            if (exists $table->{keys}->{fk}) {
                if (reftype $table->{keys}->{fk} eq 'ARRAY') {
                    my $length = scalar @{$table->{keys}->{fk}};
                    for (my $i = 0; $i < $length; $i++) {
                        push(@keys, $table->{keys}->{fk}[$i]);
                    }
                } else {
                    push(@keys, $table->{keys}->{fk});
                }
            }
        }

        my $length = scalar @keys;
        for ( my $i = 0; $i < $length; $i++ ) {
            unless ($keys[$i] eq 'companies_fkey' or $keys[$i] eq 'users_fkey') {
                $data->{keys}->{$keys[$i]} = $self->param($keys[$i])
            }
        }
    };
    $err = $@ if $@;

    return $data;
}
1;