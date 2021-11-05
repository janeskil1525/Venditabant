package venditabant::Helpers::Customers::Address;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Customer::CustomerAddress;
use venditabant::Model::Customer::Customers;

use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $users_pkey, $customer ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    my $customer_addresses_pkey;
    eval {
        if(exists $customer->{customer_addresses_pkey} and $customer->{customer_addresses_pkey} > 0) {
            $customer_addresses_pkey = await venditabant::Model::Customer::CustomerAddress->new(
                db => $db
            )->update_p(
                $companies_pkey, $users_pkey, $customer
            );
        } else {
            $customer_addresses_pkey = await venditabant::Model::Customer::CustomerAddress->new(
                db => $db
            )->insert_p(
                $companies_pkey, $users_pkey, $customer
            )
        }
        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Customers::Address', 'upsert', $err
    ) if $err;

    my $result->{data} = $customer_addresses_pkey;
    $result->{status} = $err ? $err : 'success';
    return $result;
}

async sub load_invoice_address_p($self, $companies_pkey, $users_pkey, $customers_pkey) {

    my $result = venditabant::Model::Customer::CustomerAddress->new(
        db => $self->pg->db
    )->load_invoice_address_p(
        $customers_pkey
    );

    return $result;
}

async sub load_delivery_address_p($self, $companies_pkey, $users_pkey, $customer_addresses_pkey) {

    my $result = venditabant::Model::Customer::CustomerAddress->new(
        db => $self->pg->db
    )->load_delivery_address_p(
        $customer_addresses_pkey
    );

    return $result;
}

async sub load_delivery_address_list_p($self, $companies_pkey, $users_pkey, $customers_pkey) {

    my $result = venditabant::Model::Customer::CustomerAddress->new(
        db => $self->pg->db
    )->load_delivery_address_list_p(
        $customers_pkey
    );

    return $result;
}
 async sub load_delivery_address_from_customer_list_p ($self, $companies_pkey, $users_pkey, $customer){

     my $err;
     my $result;
     eval {
         my $customers = await venditabant::Model::Customer::Customers->new(
             db => $self->pg->db
         )->load_customer(
             $companies_pkey, $customer
         );

         $result = venditabant::Model::Customer::CustomerAddress->new(
             db => $self->pg->db
         )->load_delivery_address_list_p(
             $customers->{customers_pkey}
         );
     };
     $err = $@ if $@;
     $self->capture_message (
         $self->pg, '',
         'venditabant::Helpers::Customers::Address', 'load_delivery_address_from_customer_list_p', $err
     ) if $err;

     return $result;
 }
1;