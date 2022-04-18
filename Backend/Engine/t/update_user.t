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

    my $data->{user}->{languages_fkey} = 1;
    $data->{user}->{userid} = 'wwwwwww@kalle.com';
    $data->{user}->{active} = 1;
    $data->{user}->{password} = 'wwwwwWWEEERRRww';
    $data->{user}->{username} = 'kalle olle ';
    $data->{companies_fkey} = 24;
    $data->{users_fkey} = 24;
    $data->{workflow_id} = 167;

    push @{$data->{actions}}, 'update_user';

    my $config->{engine}->{conf_path} = '/home/jan/Project/Venditabant/Backend/venditabant/conf/engine_log.conf';
    $config->{engine}->{workflows_path} = '/home/jan/Project/Venditabant/Backend/Engine/conf/workflows/';

    Engine->new(
        pg => $pg,
        config => $config
    )->execute(
        'companies', $data
    )->catch(sub{
        my $err = shift;
        print $err . '\n';
    })->wait();

    return 1;
}

ok(execute() ne '');
done_testing();

