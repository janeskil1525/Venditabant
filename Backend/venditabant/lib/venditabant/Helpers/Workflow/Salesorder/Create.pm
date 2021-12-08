package venditabant::Helpers::Workflow::Salesorder::Create;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Workflow::Factory qw(FACTORY);
use Data::Dumper;

has 'pg';



1;