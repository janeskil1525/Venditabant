#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mailer::Model::Mailtemplates;
use Mojo::Pg;

sub load_template() {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $template = Mailer::Model::Mailtemplates->new(
        db => $pg->db
    )->load_template(
        24, 24, 1, 'Invoice Mail'
    );

    return length($template->{body_value}) > 0;
}

ok(load_template() == 1);

done_testing();

