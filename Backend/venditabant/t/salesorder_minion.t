#!/usr/bin/perl
use Mojo::Base -async_await;


use Test::More;

use feature 'say' ;

use venditabant::Helpers::Minion::Salesorder;
use Mojo::Pg;

sub create {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    venditabant::Helpers::Minion::Salesorder->new(
        pg => $pg
    )->create_invoice_from_salesorder_test($pg, $salesorder)->catch(sub {
        my $err = shift;

        say $err;
    });

    return 1;
}

ok(create() ne '');


done_testing();

