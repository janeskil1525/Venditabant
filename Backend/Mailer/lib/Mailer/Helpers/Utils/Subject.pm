package Mailer::Helpers::Mailer::Mails::Utils::Subject;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Lan::Translations;

use Data::Dumper;

has 'pg';
has 'companyname';
has 'idno';
has 'languages_fkey';
has 'module';
has 'tag';

async sub get_subject($self) {

    my $err;
    my $subject;
    eval {
        my $text = await venditabant::Model::Lan::Translations->new(
            db => $self->pg->db
        )->load_translation(
            $self->languages_fkey, $self->module, $self->tag
        );
        $subject = $self->companyname . ' ' . $text->{translation} . ' ' . $self->idno;
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Mailer::Mails::Utils::Subject', 'get_subject', $err
    ) if $err;

    return $subject;
}
1;