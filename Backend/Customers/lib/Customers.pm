package Customers;
use Mojo::Base -base, -signatures, -async_await;

use Customers::Helpers::Customer;
use Customers::Helpers::Address;
use Customers::Helpers::Workflow;
use Customers::Helpers::Discounts;

our $VERSION = '1.00';

has 'pg';


async sub delete_general_discount_p($self, $companies_pkey, $users_pkey, $customer_discount_pkey) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->delete_general_discount_p (
        $companies_pkey, $users_pkey, $customer_discount_pkey
    );
}

sub delete_general_discount($self, $companies_pkey, $users_pkey, $customer_discount_pkey) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->delete_general_discount (
        $companies_pkey, $users_pkey, $customer_discount_pkey
    );
}

async sub load_list_general_discount_p ($self, $companies_pkey, $users_pkey, $customers_fkey) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->load_list_general_discount_p (
        $companies_pkey, $users_pkey, $customers_fkey
    );
}

sub load_list_general_discount ($self, $companies_pkey, $users_pkey, $customers_fkey) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->load_list_general_discount (
        $companies_pkey, $users_pkey, $customers_fkey
    );
}

async sub save_general_discount_p ($self, $companies_pkey, $users_pkey, $data) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->save_general_discount_p (
        $companies_pkey, $users_pkey, $data
    );
}

sub save_general_discount ($self, $companies_pkey, $users_pkey, $data) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->save_general_discount(
        $companies_pkey, $users_pkey, $data
    );
}

async sub load_list_productgroups_discount_p($self, $companies_pkey, $users_pkey, $customers_fkey) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->load_list_productgroups_discount_p(
        $companies_pkey, $users_pkey, $customers_fkey
    );
}

sub load_list_productgroups_discount($self, $companies_pkey, $users_pkey, $customers_fkey) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->load_list_productgroups_discount(
        $companies_pkey, $users_pkey, $customers_fkey
    );
}

async sub save_productgroups_discount_p($self, $companies_pkey, $users_pkey, $data) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->save_productgroups_discount_p(
        $companies_pkey, $users_pkey, $data
    );
}

sub save_productgroups_discount($self, $companies_pkey, $users_pkey, $data) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->save_productgroups_discount(
        $companies_pkey, $users_pkey, $data
    );
}

async sub load_list_stockitem_discount_p($self, $companies_pkey, $users_pkey, $customers_fkey) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->load_list_stockitem_discount_p(
        $companies_pkey, $users_pkey, $customers_fkey
    );
}

sub load_list_stockitem_discount($self, $companies_pkey, $users_pkey, $customers_fkey) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->load_list_stockitem_discount(
        $companies_pkey, $users_pkey, $customers_fkey
    );
}

async sub save_stockitem_discount_p($self, $companies_pkey, $users_pkey, $data) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->save_stockitem_discount_p(
        $companies_pkey, $users_pkey, $data
    );
}

sub save_stockitem_discount($self, $companies_pkey, $users_pkey, $data) {
    return Customers::Helpers::Discounts->new(
        pg => $self->pg
    )->save_stockitem_discount(
        $companies_pkey, $users_pkey, $data
    );
}

sub get_new_cust_id($self, $companies_pkey, $users_pkey) {
    return Customers::Helpers::Customer->new(
        pg => $self->pg
    )->get_new_cust_id(
        $companies_pkey, $users_pkey
    );
}

sub load_workflow_id($self, $customers_fkey) {
    return Customers::Helpers::Workflow->new(
        pg => $self->pg
    )->load_workflow_id(
        $customers_fkey
    );
}

async sub load_workflow_id_p($self, $customers_fkey) {
    return Customers::Helpers::Workflow->new(
        pg => $self->pg
    )->load_workflow_id_p(
        $customers_fkey
    );
}

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

async sub load_delivery_address_fromname_p($self, $companies_pkey, $users_pkey, $customers_pkey, $name) {
    return Customers::Helpers::Address->new(
        pg => $self->pg
    )->load_delivery_address_fromname_p(
        $companies_pkey, $users_pkey, $customers_pkey, $name
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

sub upsert_address($self, $companies_pkey, $users_pkey, $customer ) {

    return Customers::Helpers::Address->new(
        pg => $self->pg
    )->upsert(
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