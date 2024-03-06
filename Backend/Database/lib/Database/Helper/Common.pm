package Database::Helper::Common;
use Mojo::Base  -base, -signatures;

use Mojo::JSON qw { decode_json};

has 'app';

sub get_basedata($self) {


    my ($companies_pkey, $users_pkey) = $self->app->jwt->companies_users_pkey(
        $self->app->req->headers->header('X-Token-Check')
    );

    my $data->{data} = decode_json ($self->req->body);
    $data->{users_fkey} = $users_pkey;
    $data->{companies_fkey} = $companies_pkey;

    return $data;
}
1;