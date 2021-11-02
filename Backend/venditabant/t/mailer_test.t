#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use venditabant::Helpers::Mailer::System::Sender;

sub test_mail() {
    venditabant::Helpers::Mailer::System::Sender->new()->send()->catch(sub {
        my $err = shift;

        print $err . '\n';
        return 1;
    })->wait;

}
ok(test_mail == 1);
done_testing();

