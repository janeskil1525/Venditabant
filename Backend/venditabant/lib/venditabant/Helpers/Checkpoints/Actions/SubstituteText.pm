package venditabant::Helpers::Checkpoints::Actions::SubstituteText;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Company;
use venditabant::Model::Lan::Translations;

use Text::Template;
use Data::Dumper;

has 'pg';

async sub substitute($self, $companies_fkey, $check_type, $check_name, $substitute_hash) {

    my $result;
    my $err;
    eval {
        my $languages_fkey = await venditabant::Model::Company->new(
            db => $self->pg->db
        )->get_language(
            $companies_fkey
        );

        my $translation = await venditabant::Model::Lan::Translations->new(
            db => $self->pg->db
        )->load_translation($languages_fkey, $check_type, $check_name);

        $result = Text::Templat->new(
            TYPE => 'STRING', SOURCE => $translation
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