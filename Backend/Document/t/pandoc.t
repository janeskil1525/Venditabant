#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use feature 'say';

use Mojo::File;
use PDF::WebKit;

sub execute {


    my $html = "/home/jan/Publikt/24/1/INVOICE_STORE/7AAD1112-81B3-11EC-9CED-A2AC02C718D0.html";
    # my $source = Mojo::File->new($html)->slurp();
    my $pdf = "/home/jan/Publikt/24/1/INVOICE_STORE/7AAD1112-81B3-11EC-9CED-A2AC02C718D0.pdf";
    my $output;
    my $formats;
    my $md2latex;
    eval {
        my $kit = PDF::WebKit->new($html);
        my $file = $kit->to_file($pdf);
        # $md2latex = Pandoc->new(qw(-f html -t pdf --pdf-engine=pdflatex));
        # $md2latex->run({ in => \$source, out => \$output });

        # Mojo::File->new($pdf)->spurt($output);
    };
    say $@ if $@;

    # my $pandoc = pandoc;
    my $test = 1;

    return 1;
}

ok(execute() == 1);
done_testing();

