#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Document::Helpers::Mapper;
use Document::Model::Documents;
use Invoice::Helpers::Load;
use Document::Helpers::Store;
use Data::UUID;
use Invoice::Helpers::Files;
use Document::Helpers::Files;

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

    my $ug = Data::UUID->new();
    my $token = $ug->create();

    my $filename = $ug->to_string($token) . '.html';
    my $doc_path = 24 . '/' . 1 . '/';
    my $path = Document::Helpers::Store->new(
        pg => $pg
    )->store(
        $document_content, 24, 24, $doc_path, $filename, 'INVOICE_STORE'
    );

    my $file_data->{name} = $filename;
    $file_data->{path} = $doc_path . 'INVOICE_STORE/';
    $file_data->{type} = 'html';
    $file_data->{full_path} = $path;

    # Invoice::Helpers::Files->
    my $files_pkey = Document::Helpers::Files->new(pg => $pg)->insert($file_data);
    my $files_invoice->{invoice_fkey} = $data->{invoice}->{invoice_pkey};
    $files_invoice->{files_fkey} = $files_pkey;

    my $files_invoice_pkey = Invoice::Helpers::Files->new(pg => $pg)->insert($files_invoice);

    if(defined $files_invoice_pkey) {
        $files_invoice_pkey = $files_invoice_pkey;
    }
    return defined $path;
}


ok(execute() == 1);

done_testing();

