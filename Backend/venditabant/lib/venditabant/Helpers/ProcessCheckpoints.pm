package venditabant::Helpers::ProcessCheckpoints;
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

        my $releaser = venditabant::Helpers::Checkpoints::Check::->new(
            db => $self->pg->db
        );
        foreach my $company (@{$companies}) {
            await $releaser->check(
                $company->{companies_pkey}
            );
        }
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::ProcessChecpoints;', 'release', $err
    ) if $err;


}
1;