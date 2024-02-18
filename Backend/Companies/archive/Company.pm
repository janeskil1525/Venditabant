package Companies::Helpers::Company;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Data::Dumper;
use Companies::Model::Company;

has 'pg';

async sub load_p($self, $companies_pkey, $users_pkey) {

    my $result = Companies::Model::Company->new(
        db => $self->pg->db
    )->load_p(
        $companies_pkey, $users_pkey
    );

    return $result;
}

sub save_company ($self, $companies_pkey, $users_pkey, $company ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $customers_pkey = Companies::Model::Company->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $company
        );
        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;

    return $err ? $err : 'success';
}

async sub load_list ($self) {

    my $languages = await Companies::Model::Company->new(
        db => $self->pg->db
    )->load_list_p();

    return $languages;
}

async sub get_language_fkey_p($self, $companies_pkey, $users_pkey) {

    my $result = await Companies::Model::Company->new(
        db => $self->pg->db
    )->load_p(
        $companies_pkey, $users_pkey
    );

    return $result->{languages_fkey};
}
1;