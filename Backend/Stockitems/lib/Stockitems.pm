package Stockitems;
use Mojo::Base -base, -signatures, -async_await;

use Stockitems::Helpers::Stockitems;
use Stockitems::Helpers::Workflow;

our $VERSION = '0.06';

has 'pg';

sub get_new_cust_id($self, $companies_pkey, $users_pkey) {
    return Stockitems::Helpers::Stockitems->new(
        pg => $self->pg
    )->get_new_cust_id(
        $companies_pkey, $users_pkey
    );
}

async sub load_workflow_id_p($self, $stockitems_fkey) {
    return Stockitems::Helpers::Workflow->new(
        pg => $self->pg
    )->load_workflow_id_p(
        $stockitems_fkey
    );
}

sub insert_workflow($self, $workflow_id, $stockitems_fkey, $users_fkey, $companies_fkey) {
    return Stockitems::Helpers::Workflow->new(
        pg => $self->pg
    )->insert(
        $workflow_id, $stockitems_fkey, $users_fkey, $companies_fkey
    );
}

sub load_workflow_id($self, $stockitems_fkey) {
    return Stockitems::Helpers::Workflow->new(
        pg => $self->pg
    )->load_workflow_id(
        $stockitems_fkey
    );
}

sub upsert ($self, $companies_pkey, $users_pkey, $stockitem) {
    return Stockitems::Helpers::Stockitems->new(
        pg => $self->pg
    )->upsert($companies_pkey, $users_pkey, $stockitem);
}

async sub upsert_p ($self, $companies_pkey, $users_pkey, $stockitem) {
    return Stockitems::Helpers::Stockitems->new(
        pg => $self->pg
    )->upsert_p($companies_pkey, $users_pkey, $stockitem);
}

async sub load_list_p ($self, $companies_pkey) {
    return Stockitems::Helpers::Stockitems->new(
        pg => $self->pg
    )->load_list_p($companies_pkey);
}
1;