package Mailer::Helpers::Processor;
use Mojo::Base -base, -signatures;

use Data::Dumper;
use Mailer::Model::Mailtemplates;
use Mailer::Model::Mappings;
use HTML::Entities;

has 'pg';

sub create ($self, $company, $customer, $template) {

    my $mail_content = $self->create_mail_context($company, $customer, $template);


}

sub create_mail_context($self, $company, $customer, $template_name) {

    my $templaate = Mailer::Model::Mailtemplates->new(
        db => $self->pg->db
    )->load_template (
        $company->{companies_pkey}, 0, $customer->{languages_fkey}, $template_name
    );

    my $mappings = Mailer::Model::Mappings->new(
        db => $self->pg->db
    )->load_mapping(
        $template_name, 'company'
    );

    my $hash;

    foreach my $map (@{$mappings}) {
        $hash->{$map->{templ_key}} = encode_entities>($company->{$map->{source_key}});
    }

    $mappings = Mailer::Model::Mappings->new(
        db => $self->pg->db
    )->load_mapping(
        $template_name, 'customer'
    );

    foreach my $map (@{$mappings}) {
        $hash->{$map->{templ_key}} = encode_entities>($customer->{$map->{source_key}});
    }

    return $hash;
}
1;