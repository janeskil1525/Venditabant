package Customers;
use Mojo::Base -base, -signatures, -async_await;

use Customers::Helpers::Customer;

our $VERSION = '0.05';

has 'pg';

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