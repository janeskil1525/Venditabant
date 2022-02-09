#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mojo::Pg;
use Invoice::PreCheck::Customer;

sub find_customer() {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $data;

    Invoice::PreCheck::Customer->new(pg => $pg)->find_customer(24, $data)->then(sub{
        my $result = shift;

        my $temp = $data;
    })->catch(sub{
        my $err = shift;

        my $temp = $err;
    })->wait;

    return 1;
}

ok(find_customer() == 1);

done_testing();

