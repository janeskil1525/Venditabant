package Mailer::Helpers::File;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

sub load_file($self, $filename) {
    my $path = Mojo::File->new($filename);
    my $file = $path->slurp;

    return $file;
}

async sub load_file_p($self, $filename) {
    my $path = Mojo::File->new($filename);
    my $file = $path->slurp;

    return $file;
}
1;