package venditabant::Helpers::Vat::Calculate;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Parameter::Parameters;;

use Data::Dumper;

has 'pg';

async sub calculate($self, $companies_pkey, $vat_fkey, $quantity, $price) {

    my $result;
    my $vat_param = venditabant::Helpers::Parameter::Parameters->new(
        pg => $self->pg
    )->get_parameter_item_from_pkey(
        $companies_pkey, $vat_fkey
    );

    my $vat_num = $vat_param->{param_value};

    if($vat_num) {
        $vat_num =~ s/%//g;
        $result->{vat_sum} = ($vat_num / 100) * ($quantity * $price);
        $result->{vat_txt} = $vat_param->{param_value};
    } else {
        $result->{vat_sum} = 0;
        $result->{vat_txt} = ' ';
    }

    return $result;
}
1;