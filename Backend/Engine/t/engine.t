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

    my $item->{salesorders_fkey} = 0;
    $item->{quantity} = 5;
    $item->{price} = 17;
    $item->{customer_addresses_fkey} = 0;
    $item->{stockitems_fkey} = 7;

    # $item->{description} = '';
    # $item->{vat} = 0;
    # $item->{discount} = 0;
    # $item->{deliverydate} = '';
    # $item->{unit} = '';
    # $item->{account} = '';
    # $item->{vat_txt} = '';
    # $item->{discount_txt} = '';

    my $data->{workflow_id} = 0;
    $data->{salesorders_pkey} = '';
    $data->{editnum} = '';
    $data->{insby} = '';
    $data->{insdatetime} = '';
    $data->{modby} = '';
    $data->{moddatetime} = '';
    $data->{customers_fkey} = 0;
    $data->{users_fkey} = 24;
    $data->{companies_fkey} = 24;
    $data->{orderdate} = '2021-12-14';
    $data->{deliverydate} = '2021-12-14';
    $data->{open} = '';
    $data->{orderno} = 0;
    $data->{invoiced} = '';
    $data->{invoicedays_fkey} = 0;
    $data->{customer_addresses_pkey} = 17;
    push @{$data->{actions}}, 'create_order';
    push @{$data->{actions}}, 'additem_to_order';

    push @{$data->{items}}, $item;

    my $config->{engine}->{conf_path} = '/home/jan/Project/Venditabant/Backend/venditabant/conf/engine_log.conf';
    $config->{engine}->{workflows_path} = '/home/jan/Project/Venditabant/Backend/Engine/conf/workflows/';
    Engine->new(
        pg => $pg,
        config => $config
    )->execute(
        'salesorder_simple',$data
    )->catch(sub{
        my $err = shift;
        print $err . '\n';
    })->wait();

    return 1;
}

ok(execute() == 1);

done_testing();

