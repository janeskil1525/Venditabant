#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Mojo::Pg;
use Workflows;

sub export () {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );
    my $export;
    Workflows->new(
        pg => $pg
    )->export()->then(sub {
        $export = shift;
        $export = $export;
    })->catch(sub {
        my $err = shift;

        print $err . '\n';
    })->wait;

    return $export;
}

ok(export() ne '');

done_testing();

