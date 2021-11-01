package venditabant::Helpers::Mailer::Mails::Mapper::Map;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::System::Mappings;
use venditabant::Helpers::System::TextMapper;
use venditabant::Helpers::Mailer::Templates::BaseTemplate;

use Data::Dumper;

has 'pg';


async sub map_data($self, $companies_pkey, $users_pkey, $templatename, $invoice, $template) {

    my $base;
    my $err;
    eval {
        my $mapper_map = venditabant::Model::System::Mappings->new(db => $self->pg->db);
        my $header_map = await $mapper_map->load_mapping('INVOICE_HEADER');
        my $body_map = await $mapper_map->load_mapping('INVOICE_BODY');
        my $footer_map = await $mapper_map->load_mapping('INVOICE_FOOTER');

        my $mapper = venditabant::Helpers::System::TextMapper->new(pg => $self->pg);

        my $header = await $mapper->mapping($header_map, $invoice, $template->{header_value});
        my $footer = await $mapper->mapping($footer_map, $invoice, $template->{footer_value});

        my $body;
        foreach my $item (@{$invoice->{items}}) {
            $body .= await $mapper->mapping($body_map, $item, $template->{body_value});
        }

        $base = await venditabant::Helpers::Mailer::Templates::BaseTemplate->new()->getbasetemplate();

        $base =~ s/---HEADER---/$header/ig;
        $base =~ s/---BODY---/$body/ig;
        $base =~ s/---FOOTER---/$footer/ig;
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Mailer::Mails::Mapper::Map', 'map_data', $err
    ) if $err;
    return $base;
}

1;