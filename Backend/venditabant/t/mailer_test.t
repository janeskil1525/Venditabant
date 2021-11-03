#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use venditabant::Helpers::Mailer::System::Processor;

use Mojo::Pg;

sub test_mail() {
    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    venditabant::Helpers::Mailer::System::Processor->new(pg => $pg)->process(4)->catch(sub {
        my $err = shift;

        print $err . '\n';
        return 1;
    })->wait;

}
ok(test_mail == 1);
done_testing();

