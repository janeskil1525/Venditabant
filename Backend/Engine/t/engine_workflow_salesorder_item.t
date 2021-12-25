#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mojo::Pg;
use Engine::Workflow::Action::Salesorder::Item;

sub execute() {
    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $item = Engine::Workflow::Action::Salesorder::Item->new(pg => $pg);

    return 1;
}

ok(execute() == 1);
done_testing();

