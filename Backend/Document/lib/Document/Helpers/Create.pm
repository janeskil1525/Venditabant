package Document::Helpers::Create;
use Mojo::Base -base, -signatures, -async_await;

use Document::Model::Documents;
use Document::Helpers::Mapper;
use Document::Helpers::Store;

use DMS::Helpers::Files;
use Invoice::Helpers::Files;

use Data::UUID;
use Data::Dumper;

use PDF::WebKit;

has 'pg';

sub create($self, $companies_pkey, $users_pkey, $languages_pkey, $document, $data) {

    my $log = Log::Log4perl->get_logger();
    my $err;
    eval {

        my $ug = Data::UUID->new();
        my $token = $ug->create();
        $data->{id_token} = $ug->to_string($token);

        my $template = Document::Model::Documents->new(
            db => $self->pg->db
        )->load_template(
            $companies_pkey, $users_pkey, $languages_pkey, $document
        );

        my $document_content = Document::Helpers::Mapper->new(
            pg => $self->pg
        )->map_text(
            $companies_pkey, $users_pkey, $data, $template
        );

        my $filename = $data->{id_token} . '.html';
        my $doc_path = $companies_pkey . '/' . $languages_pkey . '/';
        my $path = Document::Helpers::Store->new(
            pg => $self->pg
        )->store(
            $document_content, $companies_pkey, $users_pkey, $doc_path, $filename, 'INVOICE_STORE'
        );

        my $file_data->{name} = $filename;
        $file_data->{path} = $doc_path . 'INVOICE_STORE/';
        $file_data->{type} = 'html';
        $file_data->{full_path} = $path;
        $self->_save_document($file_data, $data->{invoice}->{invoice_pkey});

        $filename = $data->{id_token} . '.pdf';

        my $pdf_path = $path;
        $pdf_path =~ s/html/pdf/ig;

        my $kit = PDF::WebKit->new($path);
        my $file = $kit->to_file($pdf_path);
        $file_data->{name} = $filename;

        $file_data->{type} = 'pdf';
        $file_data->{full_path} = $pdf_path;
        $self->_save_document($file_data, $data->{invoice}->{invoice_pkey});
    };
    $err = $@ if $@;
    $log->debug (
        'venditabant::Helpers::Mailer::Mails::Invoice::Create::create ' . $err
    ) if defined $err;

    return 1;
}

sub _save_document($self, $file_data, $invoice_pkey) {

    my $files_pkey = DMS::Helpers::Files->new(
        pg => $self->pg
    )->insert(
        $file_data
    );

    my $files_invoice->{invoice_fkey} = $invoice_pkey;
    $files_invoice->{files_fkey} = $files_pkey;

    # Måste generaliseras
    my $files_invoice_pkey = Invoice::Helpers::Files->new(
        pg => $self->pg
    )->insert(
        $files_invoice
    );

    return $files_invoice_pkey;
}
1;