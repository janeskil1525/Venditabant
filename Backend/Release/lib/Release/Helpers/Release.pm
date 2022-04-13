package Release::Helpers::Release;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Release::Helpers::Release::ReleaseSteps;
use Release::Model::Company;

use Data::Dumper;

has 'pg';

my $current_version = 6;

async sub release_single_company ($self, $companies_pkey =  0) {

    # $self->db($self->pg->db) unless $self->db;

    my $releaser = Release::Helpers::Release::ReleaseSteps->new(
        db => $self->pg->db
    );

    if ($companies_pkey > 0) {
        await $releaser->release($companies_pkey, $current_version);
    }
}

async sub release ($self) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $companies = await Release::Model::Company->new(
            db => $db
        )->load_list_p();

        my $releaser = Release::Helpers::Release::ReleaseSteps->new(
            db => $db
        );
        foreach my $company (@{$companies}) {
            await $releaser->release(
                $company->{companies_pkey}, $current_version
            );
        }
        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;


}
1;