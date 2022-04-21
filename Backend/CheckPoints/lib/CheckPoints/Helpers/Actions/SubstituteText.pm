package CheckPoints::Helpers::Actions::SubstituteText;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Companies::Helpers::Company;
use Translations::Model::Translation;

use Text::Template;
use Data::Dumper;

has 'pg';

async sub substitute($self, $companies_fkey, $check_type, $check_name, $substitute_hash) {

    my $result;
    my $err;
    eval {
        my $languages_fkey = await Companies::Helpers::Company->new(
            pg => $self->pg
        )->get_language_fkey_p(
            $companies_fkey, 0
        );

        my $translation = await Translations::Model::Translation->new(
            db => $self->pg->db
        )->load_translation(
            $languages_fkey, $check_type, $check_name
        );

        $result = Text::Template->new(
            TYPE => 'STRING', SOURCE => $translation->{translation}
        )->fill_in(
            HASH => $substitute_hash
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;

    return $result;
}
1;