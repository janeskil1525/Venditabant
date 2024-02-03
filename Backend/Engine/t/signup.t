#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Mojo::Pg;
use Engine;

sub execute {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=database;port=15432;user=postgres;password=PV58nova64"
    );

    my $data->{company}->{email} = 'kalle_pelle@olle.com';
    $data->{company}->{user_name} = 'kalle_pelle@olle.com';
    $data->{company}->{company_name} = 'kalle_pelle@olle.com';
    $data->{company}->{company_orgnr} = 'kalle_pelle@olle.com';
    $data->{company}->{company_address} = 'kalle_pelle@olle.com';
    $data->{company}->{password} = 'kalle_pelle@olle.com';

    $data->{companies_fkey} = 24;
    $data->{users_fkey} = 24;

    push @{$data->{actions}}, 'signup';

    my $config->{engine}->{conf_path} = '/home/jan/Project/Venditabant/Backend/venditabant/conf/engine_log.conf';
    $config->{engine}->{workflows_path} = '/home/jan/Project/Venditabant/Backend/Engine/conf/workflows/';


    Engine->new(
        pg => $pg,
        config => $config
    )->execute(
        'Companies',$data
    )->catch(sub{
        my $err = shift;
        print $err . '\n';
    })->wait();
    return 1;
}

ok (execute() == 1);
done_testing();

