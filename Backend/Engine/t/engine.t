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

    my $data->{workflow_id} = 0;
    $data->{salesorders_pkey} = '';
    $data->{editnum} = '';
    $data->{insby} = '';
    $data->{insdatetime} = '';
    $data->{modby} = '';
    $data->{moddatetime} = '';
    $data->{customers_fkey} = '';
    $data->{users_fkey} = '';
    $data->{companies_fkey} = '';
    $data->{orderdate} = '';
    $data->{deliverydate} = '';
    $data->{open} = '';
    $data->{orderno} = '';
    $data->{invoiced} = '';
    $data->{invoicedays_fkey} = '';

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

