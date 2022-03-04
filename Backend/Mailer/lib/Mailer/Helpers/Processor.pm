package Mailer::Helpers::Processor;
use Mojo::Base -base, -signatures;

use Data::Dumper;
use Mailer::Model::Mailtemplates;
use Mailer::Helpers::Mapper;
use Translations::Helpers::Translation;

use HTML::Entities;

has 'pg';

sub create ($self, $company, $customer, $mappings, $template) {

    my $data->{mail_content} = $self->create_mail_context($company, $customer, $mappings, $template);

    $data->{subject} = $self->create_subject($company, $customer, $template);

    return $data;
}

sub create_subject($self, $company, $customer, $mappings, $template) {

    my $text = 'Faktura från {$company_name}';
    my $text = Translations::Helpers::Translation->new(
        pg => $self->pg
    )->get_translation(
        'swe', $template, 'Subject'
    );

    my $hash->{company_name} = $company->{name};
    my $result = Mailer::Helpers::Mapper->new()->map_text(
        $hash, $text
    );

    return $result;
}

sub create_mail_context($self, $company, $customer, $mappings, $template_name) {

    my $templaate = Mailer::Model::Mailtemplates->new(
        db => $self->pg->db
    )->load_template (
        $company->{companies_pkey}, 0, $customer->{languages_fkey}, $template_name
    );

    my $hash;

    foreach my $map (@{$mappings->{map}}) {
        if($map->{source} eq 'company') {
            $hash->{$map->{templ_key}} = encode_entities($company->{$map->{source_key}});
        } elsif ($map->{source} eq 'customer') {
            $hash->{$map->{templ_key}} = encode_entities($customer->{$map->{source_key}});
        }
    }

    my $result = Mailer::Helpers::Mapper->new()->map_text(
        $hash, $templaate->{body_value}
    );

    return $result;
}
1;