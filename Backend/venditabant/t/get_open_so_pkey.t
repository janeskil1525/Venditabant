#!/usr/bin/perl
use Mojo::Base -strict;

use Test::More;

use Mojo::Pg;
use venditabant::Helpers::Salesorder::OpenSo;

sub test_openso() {
    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    venditabant::Helpers::Salesorder::OpenSo->new(
        pg => $pg
    )->get_open_so_pkey(24, 24, 17)->then(sub{
        my $response = shift;

        print $response . '\n';
    })->catch(sub {
        my $err = shift;

        print $err . '\n';
        return 1;
    })->wait;

}
ok(test_openso == 1);

done_testing();

