package Mailer::Helpers::Processor;
use Mojo::Base -base, -signatures;

use Data::Dumper;
use Mailer::Model::Mailtemplates;
use Mailer::Model::Mappings;

has 'pg';

sub create ($self, $customer, $company, $template) {



}

sub create_mail_context($self, $company, $customer, $template) {

    my $template = Mailer::Model::Mailtemplates->new(
        db => $self->pg->db
    )->load_template (
        $company->{companies_pkey}, 0, $customer->{languages_fkey}, $template
    );

    my $mappings = Mailer::Model::Mappings->new(
        db => $self->pg->db
    )->load_mapping(
        $template
    );

}
1;