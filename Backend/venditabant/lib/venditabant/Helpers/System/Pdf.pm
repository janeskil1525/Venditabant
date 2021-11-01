package venditabant::Helpers::System::Pdf;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::System::Settings;

use Data::Dumper;
use PDF::FromHTML;

has 'pg';

async sub create($self, $companies_pkey, $users_pkey, $html) {

    my $err;
    my $filename;
    eval {
        my $temp_path = await venditabant::Model::System::Settings->new(
            db => $self->pg->db
        )->load_setting(
            'TEMP_PATH'
        );
        my $ug = Data::UUID->new();
        my $token = $ug->create();
        $filename = $temp_path->{value} . $ug->to_string($token) . ".pdf";

        my $pdf = PDF::FromHTML->new( encoding => 'utf-8' );
        $pdf->load_file(\$html);
        $pdf->convert(
            # With PDF::API2, font names such as 'traditional' also works
            #Font        => 'font.ttf',
            LineHeight  => 10,
            Landscape   => 0,
            PageSize    => 'A4',
        );
        $pdf->write_file($filename);
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::System::Pdf', 'create', $err
    ) if $err;

    return $filename;
}


1;