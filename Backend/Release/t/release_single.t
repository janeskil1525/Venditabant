#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Release;
use Mojo::Pg;

sub execute {
    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    Release->new(
        pg => $pg,
        db => $pg->db
    )->release_single_company(82)->catch(sub{
        my $err = shift;
        $err = $err;
    })->wait;

    return 1;
}

ok(execute() == 1);
done_testing();

