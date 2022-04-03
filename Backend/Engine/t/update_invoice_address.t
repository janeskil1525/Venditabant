#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Engine;
use Mojo::Pg;
use Data::Dumper;

sub execute {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $data->{workflow_id} = 128;
    $data->{address}->{mailadresses} = 'ere';
    $data->{address}->{city} =  'yerye';
    $data->{address}->{zipcode} =  'yer';
    $data->{address}->{invoicedays_fkey} =  1501;
    $data->{address}->{address3} =  'eryer';
    $data->{address}->{customers_fkey} =  43;
    $data->{address}->{comment} =  'eryerery';
    $data->{address}->{customer_addresses_pkey} =  0;
    $data->{address}->{type} =  'INVOICE';
    $data->{address}->{country} =  'ryery';
    $data->{address}->{address2} =  'eryer';
    $data->{address}->{address1} =  'rtyery';
    $data->{address}->{name} =  'adsdasdbnmbnmnm';
    $data->{'companies_fkey'} = 24;
    push @{$data->{actions}}, 'update_invoiceaddress';
    $data->{users_fkey} = 24;


    print Dumper($data);
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


    return 1
}

ok(execute() == 1);
done_testing();

