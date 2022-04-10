package venditabant::Helpers::Checkpoints::Actions::MissingInvoiceAddress;
use Mojo::Base 'venditabant::Helpers::Checkpoints::Actions::SubstituteText', -signatures, -async_await;

use Text::Template;

use Data::Dumper;


async sub create_text($self, $companies_pkey, $result, $check) {

    my $text;
    my $err;
    eval {
        my $hash = {
            customer => $result->{customer},
            name    => $result->{name},
        };

        $text = await $self->substitute(
            $companies_pkey, $check->{check_type}, $check->{check_name}, $hash
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Checkpoints::Actions::MissingInvoiceAddress', 'create_text', $@
    ) if $err;

    return $text;
}

1;