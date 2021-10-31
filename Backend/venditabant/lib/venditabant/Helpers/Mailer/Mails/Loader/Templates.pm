package venditabant::Helpers::Mailer::Mails::Loader::Templates;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Mail::Mailtemplates;

use Data::Dumper;

has 'pg';

async sub load_template($self, $companies_pkey, $users_pkey, $language_fkey, $template) {

    my $template_obj = await venditabant::Model::Mail::Mailtemplates->new(
        db => $self->pg->db
    )->load_template(
        $companies_pkey, $users_pkey, $language_fkey, $template
    );

    return $template_obj;
}
1;