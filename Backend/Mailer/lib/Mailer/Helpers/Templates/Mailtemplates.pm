package Mailer::Helpers::Mailer::Templates::Mailtemplates;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;


use venditabant::Model::Mail::Mailtemplates;

use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $users_pkey, $json_hash) {
    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        if(exists $json_hash->{default_mailer_mails_pkey} and $json_hash->{default_mailer_mails_pkey} > 0) {
            my $hashes = Model::Mailtemplates->new(
                db => $db
            )->update (
                $companies_pkey, $users_pkey, $json_hash
            );
        } else {
            my $hashes = Model::Mailtemplates->new(
                db => $db
            )->upsert (
                $companies_pkey, $users_pkey, $json_hash
            );
        }

        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Mailer::Templates::Mailtemplates', 'upsert', $err
    ) if $err;

    return 'success' unless $err;
    return $err;
}

async sub load_list ($self, $mailer_pkey) {

    my $hashes = Model::Mailtemplates->new(
        db => $self->pg->db
    )->load_list(
        $mailer_pkey
    );

    return $hashes;
}

async sub load_mailer_list ($self) {

    my $hashes = Model::Mailtemplates->new(
        db => $self->pg->db
    )->load_mailer_list();

    return $hashes;
}



1;