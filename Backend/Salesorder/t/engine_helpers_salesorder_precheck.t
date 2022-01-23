#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use feature 'signatures';
use feature 'say';

use Data::Dumper;
use Mojo::Pg;
use Salesorder::PreCheck::Item;

sub execute {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $item->{salesorders_fkey} = 97;
    $item->{quantity} = 15;
    $item->{price} = 17;
    $item->{customer_addresses_fkey} = 20;
    $item->{stockitems_fkey} = 8;
    $item->{companies_fkey} = 24;
    $item->{users_fkey} = 24;

    my $config->{engine}->{conf_path} = '/home/jan/Project/Venditabant/Backend/venditabant/conf/engine_transit_log.conf';
    $config->{engine}->{workflows_path} = '/home/jan/Project/Venditabant/Backend/Engine/conf/workflows/';

    Salesorder::PreCheck::Item->new(
        pg => $pg,
    )->precheck($item)->then(sub($item) {
        say Dumper($item);
    })->catch(sub($err) {
        say $err;
    })->wait();

    return 1;
}

ok(execute() == 1);

done_testing();

