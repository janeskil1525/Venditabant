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

    my $data->{customer}->{languages_fkey} = 1;
    $data->{customer}->{customer} = 'wwwwwww';
    $data->{customer}->{name} = 'wwwwwww';
    $data->{customer}->{phone} = 'wwwwwww';
    $data->{customer}->{comment} = 'wwwwwww';
    $data->{customer}->{pricelists_fkey} = 59;
    $data->{customer}->{registrationnumber} = 'wwwwwww';
    $data->{customer}->{homepage} = 'wwwwwww';
    $data->{companies_fkey} = 24;
    $data->{users_fkey} = 24;

    push @{$data->{actions}}, 'create_customer';

    my $config->{engine}->{conf_path} = '/home/jan/Project/Venditabant/Backend/venditabant/conf/engine_log.conf';
    $config->{engine}->{workflows_path} = '/home/jan/Project/Venditabant/Backend/Engine/conf/workflows/';

    Engine->new(
        pg => $pg,
        config => $config
    )->execute(
        'customer_simple',$data
    )->catch(sub{
        my $err = shift;
        print $err . '\n';
    })->wait();

    return 1;
}

ok(execute() ne '');
done_testing();

