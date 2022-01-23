package Document::Helpers::Store;
use Mojo::Base -base, -signatures;

use Data::Dumper;
use Mojo::File;

use Document::Model::SystemSettings;

has 'pg';

sub store ($self, $document_content, $companies_pkey, $users_pkey, $languages_pkey, $filename) {

    my $response;
    my $log = Log::Log4perl->get_logger();

    my $path = Document::Model::SystemSettings->new(
        db => $self->pg->db
    )->load_setting(
        'INVOICE_STORE'
    );

    $path . $companies_pkey . '/' . $languages_pkey . '/';
    my $err;
    eval {
        my $file = Mojo::File->new();

        my $file_path = $file->path($path)->make_path;

        $response = $file_path->child($filename)->spurt($document_content);
    };
    $err = $@ if $@;
    $log->error("Document::Helpers::Store::store '$err' ") if defined $err;

    return $response;
}

1;