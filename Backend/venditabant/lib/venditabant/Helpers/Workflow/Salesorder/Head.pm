package venditabant::Helpers::Workflow::Salesorder::Head;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Workflow::Factory qw(FACTORY);
use Data::Dumper;

use venditabant::Helpers::Workflow::Config;

has 'pg';

async sub init($self) {
    my $config = venditabant::Helpers::Workflow::Config->new(
        pg => $self->pg
    )->load_config(
        'Salesorder'
    );

}

1;