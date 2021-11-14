#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mojo::Pg;

use venditabant::Helpers::Scheduler;

sub create {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    venditabant::Helpers::Scheduler->new(
        pg => $pg
    )->check_all()->catch(sub {
        my $err = shift;

        say $err;
    });

    return 1;
}

ok(create() ne '');
done_testing();

