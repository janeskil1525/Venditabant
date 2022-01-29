package Document::Helpers::Create;
use Mojo::Base -base, -signatures, -async_await;

use Document::Model::Documents;
use Document::Helpers::Mapper;
use Document::Helpers::Store;

use Document::Helpers::Files;
use Invoice::Helpers::Files;

use Data::UUID;
use Data::Dumper;

use Pandoc;

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

        # Invoice::Helpers::Files->
        my $files_pkey = Document::Helpers::Files->new(
            pg => $self->pg
        )->insert(
            $file_data
        );
        my $files_invoice->{invoice_fkey} = $data->{invoice}->{invoice_pkey};
        $files_invoice->{files_fkey} = $files_pkey;

        my $files_invoice_pkey = Invoice::Helpers::Files->new(
            pg => $self->pg
        )->insert(
            $files_invoice
        );

        # Pandoc
        $filename = $data->{id_token} . '.pdf';

        my $pdf_path = $path =~ s/html/pdf/r;
        pandoc ['-pdf-engine' => 'pdflatex', -f => 'html', -t => 'pdf'], { in => \$path, out => \$pdf_path };

        $file_data->{name} = $filename;

        $file_data->{type} = 'pdf';
        $file_data->{full_path} = $pdf_path;
        $files_pkey = Document::Helpers::Files->new(
            pg => $self->pg
        )->insert(
            $file_data
        );
        $files_invoice->{files_fkey} = $files_pkey;

        $files_invoice_pkey = Invoice::Helpers::Files->new(
            pg => $self->pg
        )->insert(
            $files_invoice
        );

    };
    $err = $@ if $@;
    $log->debug (
        'venditabant::Helpers::Mailer::Mails::Invoice::Create::create ' . $err
    ) if defined $err;

    return 1;
}

1;