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
    $data->{pricelist}->{pricelist} = 'testkalle2';
    $data->{pricelist}->{description} = 'Test prislista';

    push @{$data->{actions}}, 'create_pricelist';

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

