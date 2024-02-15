package Companies;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use Companies::Helpers::Company;
use Companies::Helpers::Workflow;

our $VERSION = '0.08';

has 'pg';

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