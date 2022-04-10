package CheckPoints::Helpers::ProcessCheckpoints;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Company;
use venditabant::Helpers::Checkpoints::Check;

has 'pg';

async sub check_all ($self) {


    my $err;
    eval {
        my $companies = await venditabant::Model::Company->new(
            db => $self->pg->db
        )->load_list_p();

        my $checker = venditabant::Helpers::Checkpoints::Check->new(
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
        $self->pg, '',
        'venditabant::Helpers::ProcessChecpoints;', 'check_all', $err
    ) if $err;


}
1;