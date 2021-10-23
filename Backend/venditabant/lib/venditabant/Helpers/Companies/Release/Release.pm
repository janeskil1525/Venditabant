package venditabant::Helpers::Companies::Release::Release;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Companies::Release::ReleaseSteps;
use venditabant::Model::Company;

use Data::Dumper;

has 'db';
has 'pg';

my $current_version = 5;

async sub release_single_company ($self, $companies_pkey =  0) {

    # $self->db($self->pg->db) unless $self->db;

    my $releaser = venditabant::Helpers::Companies::Release::ReleaseSteps->new(
        db => $self->db
    );

    if ($companies_pkey > 0) {
        await $releaser->release($companies_pkey, $current_version);
    }
}

async sub release ($self) {

    my $db = $self->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $companies = await venditabant::Model::Company->new(
            db => $self->db
        )->load_list_p();
        my $releaser = venditabant::Helpers::Companies::Release::ReleaseSteps->new(
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
        $self->pg, '',
        'venditabant::Helpers::Companies::Release::Release;', 'release', $err
    ) if $err;


}
1;