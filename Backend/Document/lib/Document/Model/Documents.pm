package Document::Model::Documents;
use Mojo::Base -base, -signatures;

use Data::Dumper;

has 'db';

sub load_template($self, $companies_pkey, $users_pkey, $language_fkey, $template) {

    my $result = $self->db->select(
        ['default_documents',
            ['documents', 'documents_pkey' => 'documents_fkey']],
        ['header_value', 'body_value', 'footer_value','sub1', 'sub2', 'sub3'],
        {
            languages_fkey => $language_fkey,
            document       => $template,
        }
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return $hash
}
1;