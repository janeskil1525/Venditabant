#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mojo::Pg;
use Mailer::Helpers::Processor;

sub create() {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $customer->{languages_fkey} = 1;
    my $company->{companies_pkey} = 24;

    my $template = Mailer::Helpers::Processor->new(
        pg => $pg
    )->create(
        $company, $customer, 'Invoice Mail'
    );

    return 1;
}

ok(create() == 1);
done_testing();

