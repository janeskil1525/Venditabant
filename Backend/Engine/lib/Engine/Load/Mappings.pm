package Engine::Load::Mappings;
use Mojo::Base -base, -signatures, -async_await;

use Engine::Config::Configuration;

use Workflow::Exception qw( configuration_error );
use Log::Log4perl qw(:easy);

has 'pg';

async sub mappings($self, $workflow, $data) {

    my $types = "('mappings')";

    my $config = await Engine::Config::Configuration->new(
        pg => $self->pg
    )->load_config(
        $workflow, $types
    );


    $data->{mappings} = $config if(defined $config) ;

    return $data;

}

1;