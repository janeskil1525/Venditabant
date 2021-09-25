package venditabant::Helpers::Companies::Release::Release;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Companies::Release::ReleaseSteps;
use venditabant::Model::Company;

use Data::Dumper;

has 'pg';

async sub release ($self, $companies_pkey =  0) {

    my $current_vesrion = 1;
    my $releaser = venditabant::Helpers::Companies::Release::ReleaseSteps->new(
        pg => $self->pg
    );

    if ($companies_pkey > 0) {
        $releaser->release($companies_pkey, $current_vesrion);
    } else {
        my $companies = venditabant::Model::Company->new(db => $self->pg->db);
        foreach my $company ($companies) {
            $releaser->release($companies->{companies_pkey}, $current_vesrion);
        }
    }
}
1;