package venditabant::Helpers::Vat::Calculate;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;


use Data::Dumper;

has 'pg';

async sub calculate($self, $vat, $quantity, $price) {

    my $vat_num = $vat;
    $vat_num =~ s/%//g;

    my $result->{vat_sum} = ($vat_num / 100) * ($quantity * $price);
    $result->{vat_txt} = $vat;

    return $result;
}
1;