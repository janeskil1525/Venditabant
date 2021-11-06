package venditabant::Helpers::Checkpoints::Actions::MissingDeliveryAddress;
use Mojo::Base 'venditabant::Helpers::Checkpoints::Actions::SubstituteText', -signatures, -async_await;

use Text::Template;

use Data::Dumper;


async sub create_text($self, $companies_pkey, $result, $check) {

    my $text;
    my $err;
    eval {
        my $hash = {
            company => $result->{company},
            name    => $result->{name},
        };

        my $text = $self->substitute(
            $companies_pkey, $check->{check_type}, $check->{check_name}, $hash
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Checkpoints::Actions::MissingDeliveryAddress', 'create_text', $@
    ) if $err;

    return $text;
}

1;