package venditabant::Helpers::System::TextMapper;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

async sub mapping($self, $mapings, $data, $text) {

    foreach my $map (@{$mappings}) {
        $text =~ s/$map->{map_key}/$data->{$map->{map_table}}->{$map->{map_field}}/ig;
    }

    return $text;
}
1;