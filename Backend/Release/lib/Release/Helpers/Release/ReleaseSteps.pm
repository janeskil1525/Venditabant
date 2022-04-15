package Release::Helpers::Release::ReleaseSteps;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures;

use Release::Model::CompanyVersion;
use Release::Helpers::Loader;

use Data::Dumper;

has 'db';

sub release ($self, $companies_pkey, $current_version) {

    my $class = 'Release::Helpers::Release::ReleaseStep_';
    my $version = $self->get_version($companies_pkey);

    return unless ($current_version - 1) > $version;

    my $load = Release::Helpers::Loader->new(
        db => $self->db
    );

    for(my $i = $version; $i < $current_version; $i++) {
        my $obj = $load->load_class($class . $i);
        $obj->step($companies_pkey);
        $self->set_version($companies_pkey, $i);
    }
}

sub get_version($self, $companies_pkey) {

    my $version = Release::Model::CompanyVersion->new(
        db => $self->db
    )->get_version(
        $companies_pkey
    );
}

sub set_version($self, $companies_pkey, $version) {

    my $version_obj = Release::Model::CompanyVersion->new(
        db => $self->db
    )->set_version(
        $companies_pkey, $version
    );
}
1;