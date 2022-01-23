#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mojo::Pg;
use Engine;

sub execute {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $item->{salesorders_fkey} = 103;
    $item->{quantity} = 15;
    $item->{price} = 17;
    $item->{customer_addresses_fkey} = 20;
    $item->{stockitems_fkey} = 8;
    $item->{companies_fkey} = 24;
    $item->{users_fkey} = 24;
    push @{$item->{actions}}, 'additem_to_order';
    #
    my $config->{engine}->{conf_path} = '/home/jan/Project/Venditabant/Backend/venditabant/conf/engine_transit_log.conf';
    $config->{engine}->{workflows_path} = '/home/jan/Project/Venditabant/Backend/Engine/conf/workflows/';

    Engine->new(
        pg => $pg,
        config => $config
    )->execute(
        'salesorder_simple',$item
    )->catch(sub{
        my $err = shift;
        print $err . '\n';
    })->wait();

    return 1;
}

ok(execute() == 1);
done_testing();