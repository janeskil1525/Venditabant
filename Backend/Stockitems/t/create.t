#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Stockitems::Workflow::Action::Create;

sub execute {

    return 1;
}

ok(execute() == 1);
done_testing();

