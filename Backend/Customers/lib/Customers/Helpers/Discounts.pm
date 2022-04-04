package Customers::Helpers::Discounts;
use Mojo::Base -base, -signatures, -async_await;

use Customers::Model::Stockitem;
use Customers::Model::Productgroups;
use Customers::Model::General;

use Data::Dumper;

has 'pg';

sub save_stockitem_discount ($self, $companies_pkey, $users_pkey, $data) {

    my $err;
    my $result;

    eval {
        $result = Customers::Model::Stockitem->new(
            db => $self->pg->db
        )->upsert(
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}

async sub save_stockitem_discount_p($self, $companies_pkey, $users_pkey, $data) {

    my $err;
    my $result;

    eval {
        $result = await Customers::Model::Stockitem->new(
            db => $self->pg->db
        )->upsert_p(
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}

sub load_list_stockitem_discount($self, $companies_pkey, $users_pkey, $customers_fkey) {

    my $result;
    my $err;

    eval {
        $result = Customers::Model::Stockitem->new(
            db => $self->pg->db
        )->load_list(
            $companies_pkey, $users_pkey, $customers_fkey
        );
    };
    $err = $@ if $@;

    return $result;
}

async sub load_list_stockitem_discount_p($self, $companies_pkey, $users_pkey, $customers_fkey) {

    my $result;
    my $err;

    eval {
        $result = await Customers::Model::Stockitem->new(
            db => $self->pg->db
        )->load_list_p(
            $companies_pkey, $users_pkey, $customers_fkey
        );
    };
    $err = $@ if $@;

    return $result;
}

sub save_productgroups_discount($self, $companies_pkey, $users_pkey, $data) {

    my $err;
    my $result;

    eval {
        $result = Customers::Model::Productgroups->new(
            db => $self->pg->db
        )->upsert(
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}

async sub save_productgroups_discount_p($self, $companies_pkey, $users_pkey, $data) {

    my $err;
    my $result;

    eval {
        $result = await Customers::Model::Productgroups->new(
            db => $self->pg->db
        )->upsert_p(
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}

sub load_list_productgroups_discount($self, $companies_pkey, $users_pkey, $customers_fkey) {

    my $result;
    my $err;

    eval {
        $result = Customers::Model::Productgroups->new(
            db => $self->pg->db
        )->load_list(
            $companies_pkey, $users_pkey, $customers_fkey
        );
    };
    $err = $@ if $@;

    return $result;
}

async sub load_list_productgroups_discount_p($self, $companies_pkey, $users_pkey, $customers_fkey) {

    my $result;
    my $err;

    eval {
        $result = await Customers::Model::Productgroups->new(
            db => $self->pg->db
        )->load_list_p(
            $companies_pkey, $users_pkey, $customers_fkey
        );
    };
    $err = $@ if $@;

    return $result;
}

sub save_general_discount ($self, $companies_pkey, $users_pkey, $data) {

    my $err;
    my $result;

    eval {
        $result = Customers::Model::General->new(
            db => $self->pg->db
        )->upsert (
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}

async sub save_general_discount_p ($self, $companies_pkey, $users_pkey, $data) {

    my $err;
    my $result;

    eval {
        $result = await Customers::Model::General->new(
            db => $self->pg->db
        )->upsert_p (
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}

sub load_list_general_discount ($self, $companies_pkey, $users_pkey, $customers_fkey) {

    my $result;
    my $err;

    eval {
        $result = Customers::Model::General->new(
            db => $self->pg->db
        )->load_list(
            $companies_pkey, $users_pkey, $customers_fkey
        );
    };
    $err = $@ if $@;

    return $result;
}

async sub load_list_general_discount_p ($self, $companies_pkey, $users_pkey, $customers_fkey) {

    my $result;
    my $err;

    eval {
        $result = await Customers::Model::General->new(
            db => $self->pg->db
        )->load_list_p(
            $companies_pkey, $users_pkey, $customers_fkey
        );
    };
    $err = $@ if $@;

    return $result;
}

sub delete_general_discount($self, $companies_pkey, $users_pkey, $customer_discount_pkey) {

    my $err;
    eval {
        Customers::Model::General->new(
            db => $self->pg->db
        )->delete(
            $companies_pkey, $users_pkey, $customer_discount_pkey
        );
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}

async sub delete_general_discount_p($self, $companies_pkey, $users_pkey, $customer_discount_pkey) {

    my $err;
    eval {
        await Customers::Model::General->new(
            db => $self->pg->db
        )->delete_p(
            $companies_pkey, $users_pkey, $customer_discount_pkey
        );
    };
    $err = $@ if $@;

    return $err ? $err : 'success';
}
1;