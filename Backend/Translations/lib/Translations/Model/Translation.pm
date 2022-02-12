package Translations::Model::Translation;
use Mojo::Base -base, -signatures;

has 'db';


sub get_translation($self, $lan, $module, $tag) {

    my $stmt = qq{
        SELECT translation FROM translations
            WHERE   languages_fkey = (SELECT languages_pkey FROM languages WHERE lan = ?)
                    AND module = ? AND tag = ?
    };

    my $result = $self->db->query(
        $stmt,($lan, $module, $tag)
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return unless exists $hash->{translation};
    return $hash->{translation};
}

1;