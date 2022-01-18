package RuleEngine;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

has 'pg';

our $VERSION = '0.01';

sub execute ($self, $ruleset, $data) {



}
1;