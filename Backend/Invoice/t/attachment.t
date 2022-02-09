#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Invoice::Helpers::Files;

use Mojo::Pg;

sub load_file() {
    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $file = Invoice::Helpers::Files->new(
        pg => $pg
    )->load_file(
        25, 'pdf'
    );

    return 1;
}

ok(load_file() == 1);
done_testing();

