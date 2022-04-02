package Customers;
use Mojo::Base -base, -signatures, -async_await;

use Customers::Helpers::Customer;
use Customers::Helpers::Address;

our $VERSION = '0.09';

has 'pg';

async sub load_delivery_address_from_company_list($self, $companies_pkey, $users_pkey) {
    return Customers::Helpers::Address->new(
        pg => $self->pg
    )->load_delivery_address_from_customer_list_p (
        $companies_pkey, $users_pkey
    );
}

async sub load_delivery_address_from_customer_list_p ($self, $companies_pkey, $users_pkey, $customer){
    return Customers::Helpers::Address->new(
        pg => $self->pg
    )->load_delivery_address_from_customer_list_p (
        $companies_pkey, $users_pkey, $customer
    );
}

async sub load_delivery_address_list_p($self, $companies_pkey, $users_pkey, $customers_pkey) {
    return Customers::Helpers::Address->new(
        pg => $self->pg
    )->load_delivery_address_list_p(
        $companies_pkey, $users_pkey, $customers_pkey
    );
}

async sub load_delivery_address_p($self, $companies_pkey, $users_pkey, $customer_addresses_pkey) {
    return Customers::Helpers::Address->new(
        pg => $self->pg
    )->load_delivery_address_p(
        $companies_pkey, $users_pkey, $customer_addresses_pkey
    );
}

sub load_invoice_address($self, $companies_pkey, $users_pkey, $customers_pkey) {
    return Customers::Helpers::Address->new(
        pg => $self->pg
    )->load_invoice_address(
        $companies_pkey, $users_pkey, $customers_pkey
    );
}

async sub load_invoice_address_p($self, $companies_pkey, $users_pkey, $customers_pkey) {
    return Customers::Helpers::Address->new(
        pg => $self->pg
    )->load_invoice_address_p(
        $companies_pkey, $users_pkey, $customers_pkey
    );
}

async sub upsert_address_p($self, $companies_pkey, $users_pkey, $customer ) {

    return Customers::Helpers::Address->new(
        pg => $self->pg
    )->upsert_p(
        $companies_pkey, $users_pkey, $customer
    );
}

sub invoice_customer ($self, $customer_pkey) {
    return Customers::Helpers::Customer->new(
        pg => $self->pg
    )->invoice_customer(
        $customer_pkey
    );
}

async sub load_list ($self, $companies_pkey, $users_pkey) {
    return Customers::Helpers::Customer->new(
        pg => $self->pg
    )->load_list(
        $companies_pkey, $users_pkey
    );
}

sub upsert ($self, $companies_pkey, $users_pkey, $customers ) {
    return Customers::Helpers::Customer->new(
        pg => $self->pg
    )->upsert(
        $companies_pkey, $users_pkey, $customers
    );
}

async sub upsert_p ($self, $companies_pkey, $users_pkey, $customers ) {

    return Customers::Helpers::Customer->new(
        pg => $self->pg
    )->upsert_p(
        $companies_pkey, $users_pkey, $customers
    );
}
1;