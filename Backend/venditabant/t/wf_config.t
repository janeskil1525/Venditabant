#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mojo::Pg;

use venditabant::Helpers::Workflow::Config;

sub load_config {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.116;port=15432;user=postgres;password=PV58nova64"
    );

    venditabant::Helpers::Workflow::Config->new(
        pg => $pg
    )->load_config('Salesorder');

    return 1;
}

ok(load_config() ne '');
done_testing();


