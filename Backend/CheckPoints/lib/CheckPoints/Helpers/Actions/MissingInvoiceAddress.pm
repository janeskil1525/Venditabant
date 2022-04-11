package CheckPoints::Helpers::Actions::MissingInvoiceAddress;
use Mojo::Base 'CheckPoints::Helpers::Actions::SubstituteText', -signatures, -async_await;

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
        $self->pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;

    return $text;
}

1;