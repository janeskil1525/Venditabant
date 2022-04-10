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

    my $data->{companies_fkey} = 24;
    $data->{users_fkey} = 24;
    $data->{workflow_id} = 148;
    $data->{pricelist}->{todate} = '2025-04-09T22:00:00.000Z';
    $data->{pricelist}->{price} = '37';
    $data->{pricelist}->{stockitems_fkey} = 108;
    $data->{pricelist}->{pricelists_fkey} = 566 ;
    $data->{pricelist}->{fromdate} = '2022-04-09T22:00:00.000Z';
    $data->{pricelist}->{pricelist} = 'testkalle2';

    push @{$data->{actions}}, 'update_pricelist';

    my $config->{engine}->{conf_path} = '/home/jan/Project/Venditabant/Backend/venditabant/conf/engine_log.conf';
    $config->{engine}->{workflows_path} = '/home/jan/Project/Venditabant/Backend/Engine/conf/workflows/';

    Engine->new(
        pg => $pg,
        config => $config
    )->execute(
        'pricelist_simple',$data
    )->catch(sub{
        my $err = shift;
        print $err . '\n';
    })->wait();

    return 1;


}

ok(execute () == 1);
done_testing();

