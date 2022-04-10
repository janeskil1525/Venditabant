package CheckPoints;
use Mojo::Base -base, -signatures, -async_await;

use venditabant::Model::Company;
use CheckPoints::Helpers::Check;

our $VERSION = '0.01';

has 'pg';

async sub check_all ($self) {


    my $err;
    eval {
        my $companies = await venditabant::Model::Company->new(
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

}

1;