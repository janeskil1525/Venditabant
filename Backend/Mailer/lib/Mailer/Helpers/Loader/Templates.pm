package Mailer::Helpers::Mailer::Mails::Loader::Templates;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Mail::Mailtemplates;

use Data::Dumper;

has 'pg';

async sub load_template($self, $companies_pkey, $users_pkey, $languages_fkey, $template) {

    my $err;
    my $template_obj;
    eval {
        $template_obj = await Model::Mailtemplates->new(
            db => $self->pg->db
        )->load_template(
            $companies_pkey, $users_pkey, $languages_fkey, $template
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Mailer::Mails::Loader::Templates', 'load_template', $err
    ) if $err;

    return $template_obj;
}
1;