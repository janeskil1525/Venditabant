#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Engine;
use Mojo::Pg;

sub execute {
    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $data->{stockitem}->{description} = 'WERWER_XXXXX2222XXXXX';
    $data->{stockitem}->{units_fkey} = 3485;
    $data->{stockitem}->{todate} = '2027-4-7';
    $data->{stockitem}->{active} = 1;
    $data->{stockitem}->{stocked} = 0;
    $data->{stockitem}->{fromdate} = '2022-4-7 15:43:43';
    $data->{stockitem}->{currencies_fkey} = '';
    $data->{stockitem}->{productgroup_fkey} = 1315;
    $data->{stockitem}->{vat_fkey} = 129;
    $data->{stockitem}->{accounts_fkey} = 3480;
    $data->{stockitem}->{stockitem} = 'ERWERWREWER_XXXXX222XXXXX';
    $data->{stockitem}->{purchaseprice} = '12';
    $data->{stockitem}->{price} = '12';
    $data->{stockitem}->{customer} = 'wwwwwww';
    $data->{companies_fkey} = 24;
    $data->{users_fkey} = 24;

    push @{$data->{actions}}, 'create_stockitem';

    my $config->{engine}->{conf_path} = '/home/jan/Project/Venditabant/Backend/venditabant/conf/engine_log.conf';
    $config->{engine}->{workflows_path} = '/home/jan/Project/Venditabant/Backend/Engine/conf/workflows/';

    Engine->new(
        pg => $pg,
        config => $config
    )->execute(
        'stockitem_simple',$data
    )->catch(sub{
        my $err = shift;
        print $err . '\n';
    })->wait();

    return 1;
}

ok(execute() == 1);
done_testing();

