package Document::Helpers::Store;
use Mojo::Base -base, -signatures;

use Data::Dumper;

use Mojo::File;

has 'pg';

sub store ($self, $document_content, $path, $filename) {

    my $log = Log::Log4perl->get_logger();
    my $err;
    eval {
        my $file = Mojo::File->new();

        my $file_path = $file->path($path)->make_path;

        $file_path->child($filename)->spurt($document_content);
    };
    $err = $@ if $@;
    $log->error("Document::Helpers::Store::store '$err' ") if defined $err;

}

1;