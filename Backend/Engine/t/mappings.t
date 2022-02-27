#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use feature 'signatures';

use Mojo::Pg;
use Engine::Load::Mappings;

sub mapping() {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $data;
    Engine::Load::Mappings->new(pg => $pg)->mappings('invoice_mail', 'create_mail', $data)->then(sub{
        my $result = shift;

        $result = $result;

    })->catch(sub{
        my $err = shift;

        $err = $err;

    })->wait;

}

ok(mapping() == 1);

done_testing();

