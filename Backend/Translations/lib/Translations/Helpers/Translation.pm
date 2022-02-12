package Translations::Helpers::Translation;
use Mojo::Base -base, -signatures;

use Data::Dumper;

use Translations::Model::Translation;

has 'pg';

sub get_translation($self, $lan, $module, $tag) {

    my $test = Translations::Model::Translation->new(
        db => $self->pg->db
    )->get_translation(
        $lan, $module, $tag
    );

    return $test ? $test : 'No translation available';
}
1;