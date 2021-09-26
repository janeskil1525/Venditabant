package venditabant::Helpers::Companies::Release::ReleaseSteps;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::CompanyVersion;
use venditabant::Helpers::Factory::Loader;;

use Data::Dumper;


has 'db';

async sub release ($self, $companies_pkey, $current_version) {


    my $class = 'venditabant::Helpers::Companies::Release::ReleaseStep_';
    my $version = await $self->get_version($companies_pkey);

    return unless $current_version > $version;

    my $load = venditabant::Helpers::Factory::Loader->new(
        db => $self->db
    );

    for(my $i = $version; $i < $current_version; $i++) {
        my $obj = $load->load_class($class . $i);
        await $obj->step();
        await $self->set_version($companies_pkey, $i);
    }
}

async sub get_version($self, $companies_pkey) {

    my $version = venditabant::Model::CompanyVersion->new(
        db => $self->db
    )->get_version(
        $companies_pkey
    );
}
1;