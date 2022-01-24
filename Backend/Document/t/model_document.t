#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Document::Model::Documents;
use Mojo::Pg;

sub execute {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );


   my $template = Document::Model::Documents->new(
        db => $pg->db
    )->load_template(
        24,
        24,
        1,
        'Invoice'
    );

    return defined $template;
}


ok(execute() == 1);

done_testing();

