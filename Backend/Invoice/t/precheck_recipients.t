#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mojo::Pg;
use Invoice::PreCheck::Recipients;

sub recipients() {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $data;
    Invoice::PreCheck::Recipients->new(pg => $pg)->find_recipients(24, $data)->then(sub{
        my $result = shift;

        my $temp = $result;
    })->catch(sub{
        my $err = shift;

        my $temp = $err;
    })->wait;

    return 1;
}

ok(recipients() == 1);
done_testing();

