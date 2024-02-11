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

    my $data->{company}->{company_name} = 'Test companyy';
    $data->{company}->{company_orgnr} = '12345';
    $data->{company}->{company_address} = 'Kuligastan';

    $data->{companies_fkey} = 0;


    push @{$data->{actions}}, 'create_company';

    my $config->{engine}->{conf_path} = '/home/jan/Project/Venditabant/Backend/venditabant/conf/engine_log.conf';
    #$config->{engine}->{workflows_path} = '/home/jan/Project/Venditabant/Backend/Engine/conf/workflows/';


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
