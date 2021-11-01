package venditabant::Helpers::Files::File;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'pg';

async sub load_file($self, $filename) {
    my $path = Mojo::File->new($filename);
    my $file = $path->slurp;

    return $file;
}
1;