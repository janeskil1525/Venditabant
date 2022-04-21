package CheckPoints;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use CheckPoints::Model::Company;
use CheckPoints::Helpers::Check;

our $VERSION = '0.05';

has 'pg';

async sub check_all ($self) {

    my $err;
    eval {
        my $companies = await CheckPoints::Model::Company->new(
            db => $self->pg->db
        )->load_list_p();

        my $checker = CheckPoints::Helpers::Check->new(
            pg => $self->pg
        );
        foreach my $company (@{$companies}) {
            await $checker->check(
                $company->{companies_pkey}
            );
        }
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;
}

1;