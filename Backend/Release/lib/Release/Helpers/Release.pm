package Release::Helpers::Release;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures;

use Release::Helpers::Release::ReleaseSteps;
use Release::Model::Company;

use Data::Dumper;

has 'pg';
has 'db';

my $current_version = 8;

sub release_single_company ($self, $companies_pkey =  0) {


    my $releaser = Release::Helpers::Release::ReleaseSteps->new(
        db => $self->db
    );

    if ($companies_pkey > 0) {
        $releaser->release($companies_pkey, $current_version);
    }

    return 1;
}

sub release ($self) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $companies = Release::Model::Company->new(
            db => $db
        )->load_list();

        my $releaser = Release::Helpers::Release::ReleaseSteps->new(
            db => $db
        );
        foreach my $company (@{$companies}) {
            $releaser->release(
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