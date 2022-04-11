#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mojo::Pg;
use Sentinel::Helpers::Sentinelsender;

sub capture_message_test() {

    my $test = '';

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    Sentinel::Helpers::Sentinelsender->new()->capture_message(
        $pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], 'Test meddelande'
    );
}

ok(capture_message_test() == 1);
done_testing();

