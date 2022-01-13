package Document::Helpers::Create;
use Mojo::Base -base, -signatures, -async_await;

use Document::Model::Documents;
use Document::Helpers::Mapper;
use Document::Helpers::Store;

use Data::UUID;
use Data::Dumper;

has 'pg';

sub create($self, $companies_pkey, $users_pkey, $languages_pkey, $document, $data) {

    my $err;
    eval {

        my $ug = Data::UUID->new();
        my $token = $ug->create();
        $data->{id_token} = $ug->to_string($token);

        my $template = Document::Model::Documents->new(
            pg => $self->pg
        )->load_template(
            $companies_pkey, $users_pkey, $languages_pkey, $document
        );

        my $document_content = Document::Helpers::Mapper->new(
            pg => $self->pg
        )->map_text(
            $companies_pkey, $users_pkey, $data, $template
        );

        Document::Helpers::Store->new(
            pg => $self->pg
        )->store(
            $document_content,

        );

    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Mailer::Mails::Invoice::Create', 'create', $err
    ) if $err;
}

1;