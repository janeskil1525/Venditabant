package venditabant::Helpers::Companies::Company;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use Data::Dumper;

has 'pg';

async sub load_p($self, $companies_pkey, $users_pkey) {

    my $result = venditabant::Model::Company->new(
        db => $self->pg->db
    )->load_p(
        $companies_pkey, $users_pkey
    );

    return $result;
}

async sub save_company ($self, $companies_pkey, $users_pkey, $company ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $customers_pkey = venditabant::Model::Company->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $company
        );
        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Companies::Company', 'save_company', $err
    ) if $err;

    return $err ? $err : 'success';
}

async sub load_list ($self) {

    my $languages = await venditabant::Model::Company->new(
        db => $self->pg->db
    )->load_list_p();


    return $languages;
}

1;