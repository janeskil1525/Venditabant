#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Document::Helpers::Mapper;
use Document::Model::Documents;
use Invoice::Helpers::Load;
use Log::Log4perl qw(:easy);

use Mojo::Pg;

sub execute {

    my $logpath = "/home/jan/Project/Venditabant/Backend/venditabant/conf/";

    Log::Log4perl->easy_init($ERROR);
    Log::Log4perl::init($logpath . 'engine_transit_log.conf');

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    my $data = Invoice::Helpers::Load->new(
        pg => $pg
    )->load_invoice_full(
        24,
        24,
        25
    );

    my $template = Document::Model::Documents->new(
        db => $pg->db
    )->load_template(
        24,
        24,
        1,
        'Invoice'
    );

    my $document_content = Document::Helpers::Mapper->new(
        db => $pg->db
    )->map_text(
        24,
        24,
        $data,
        $template
    );

    return defined $document_content;
}


ok(execute() == 1);

done_testing();

