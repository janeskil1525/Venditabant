#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mojo::Pg;
use Invoice::PreCheck::Company;

sub load_company() {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $data;

    Invoice::PreCheck::Company->new(pg => $pg)->load_company(24, $data)->then(sub{
        my $result = shift;

        my $temp = $data;
    })->catch(sub{
        my $err = shift;

        my $temp = $err;
    })->wait;

    return 1;
}

ok(load_company() == 1);

done_testing();

