package Mailer::Helpers::Mailer::Mails::Utils::Recipients;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Users;

use Data::Dumper;

has 'pg';
has 'mailaddresses';
has 'users_pkey';
has 'companies_pkey';

async sub get_recipients($self) {

    my $err;
    my $recipients;
    eval {
        my $user = venditabant::Model::Users->new(
            db => $self->pg->db
        )->load_user_from_pkey(
            $self->users_pkey()
        );

        $recipients = $self->mailaddresses();
        $recipients .= ",$user->{username}";
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Mailer::Mails::Utils::Recipients', 'get_recipients', $err
    ) if $err;

    return $recipients;
}
1;