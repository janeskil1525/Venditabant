package Engine::Load::Mappings;
use Mojo::Base -base, -signatures;

use Engine::Config::Configuration;

use Workflow::Exception qw( configuration_error );
use Log::Log4perl qw(:easy);

has 'pg';

sub mappings($self, $workflow, $action, $data) {

    my $types = "('mappings')";

    my $config = Engine::Config::Configuration->new(
        pg => $self->pg
    )->load_config(
        $workflow, $types
    );

    if(defined $config and exists $config->{mappings}) {
        if (ref $config->{mappings}->{groups} eq 'ARRAY') {
            foreach my $group (@{$config->{mappings}->{groups}}) {
                if ($group->{condition} eq $action) {
                    $data->{mappings} = $group
                }
            }
        } else {
            if($config->{mappings}->{groups}->{condition} eq $action) {
                $data->{mappings} = $config->{mappings}->{groups}
            }
        }
    }

    return $data;
}

1;