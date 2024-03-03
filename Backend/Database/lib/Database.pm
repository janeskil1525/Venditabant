package Database;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

our $VERSION = '0.01';

has 'pg';
has 'log';



1;