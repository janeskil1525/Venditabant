package venditabant::Helpers::Checkpoints::Actions::SubstituteText;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Companies::Company;
use venditabant::Model::Lan::Translations;

use Text::Template;
use Data::Dumper;

has 'pg';

async sub substitute($self, $companies_fkey, $check_type, $check_name, $substitute_hash) {

    my $result;
    my $err;
    eval {
        my $languages_fkey = await venditabant::Helpers::Companies::Company->new(
            pg => $self->pg
        )->get_language_fkey_p(
            $companies_fkey, 0
        );

        my $translation = await venditabant::Model::Lan::Translations->new(
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
        $self->pg, '',
        'venditabant::Helpers::Checkpoints::Actions::SubstituteText', 'substitute', $@
    ) if $err;

    return $result;
}
1;