package Companies;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Companies::Helpers::Users;
use Companies::Helpers::Company;
use Companies::Helpers::Workflow;

our $VERSION = '0.05';

has 'pg';

async sub load_users_list_support ($self) {
    return Companies::Helpers::Users->new(
        pg => $self->pg
    )->load_list_support();
}

sub upsert_user ($self, $companies_pkey, $user) {
    return Companies::Helpers::Users->new(
        pg => $self->pg
    )->upsert(
        $companies_pkey, $user
    );
}

async sub upsert_user_p ($self, $companies_pkey, $user) {
    return Companies::Helpers::Users->new(
        pg => $self->pg
    )->upsert(
        $companies_pkey, $user
    );
}

async sub load_users_list_p ($self, $companies_pkey) {
    return Companies::Helpers::Users->new(
        pg => $self->pg
    )->load_list(
        $companies_pkey
    );
}

async sub load_p($self, $companies_pkey, $users_pkey) {
    return Companies::Helpers::Company->new(
        pg => $self->pg
    )->load_p(
        $companies_pkey, $users_pkey
    );
}

async sub save_company ($self, $companies_pkey, $users_pkey, $company ) {
    return Companies::Helpers::Company->new(
        pg => $self->pg
    )->save_company(
        $companies_pkey, $users_pkey, $company
    );
}

async sub load_list ($self) {
    return Companies::Helpers::Company->new(
        pg => $self->pg
    )->load_list( );
}

async sub get_language_fkey_p($self, $companies_pkey, $users_pkey) {
    return Companies::Helpers::Company->new(
        pg => $self->pg
    )->get_language_fkey_p($companies_pkey, $users_pkey);
}

sub load_workflow_id($self, $companies_pkey) {
    return Companies::Helpers::Workflow->new(
        pg => $self->pg
    )->load_workflow_id(
        $companies_pkey
    );
}
1;