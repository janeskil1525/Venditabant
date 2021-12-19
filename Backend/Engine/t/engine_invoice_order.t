#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Mojo::Pg;
use Engine;

sub execute() {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );
    my $data->{minion} = 'create_invoice_from_salesorder';
    $data->{users_pkey} = 24;
    $data->{companies_pkey} = 24;
    $data->{salesorders_pkey} = 96;
    $data->{workflow_id} = 44;
    push @{$data->{actions}}, 'invoice_order';

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

