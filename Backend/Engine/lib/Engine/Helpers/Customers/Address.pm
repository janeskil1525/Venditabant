package Engine::Helpers::Customers::Address;
use Mojo::Base -base, -signatures, -async_await;

use Engine::Model::Customer::CustomerAddress;
use Engine::Model::Customer::Customers;

use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $users_pkey, $customer ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    my $customer_addresses_pkey;
    eval {
        if(exists $customer->{customer_addresses_pkey} and $customer->{customer_addresses_pkey} > 0) {
            $customer_addresses_pkey = await Engine::Model::Customer::CustomerAddress->new(
                db => $db
            )->update_p(
                $companies_pkey, $users_pkey, $customer
            );
        } else {
            $customer_addresses_pkey = await Engine::Model::Customer::CustomerAddress->new(
                db => $db
            )->insert_p(
                $companies_pkey, $users_pkey, $customer
            );
            if($customer->{type} eq 'INVOICE'){
                my $exists = await Engine::Model::Customer::CustomerAddress->new(
                    db => $db
                )->address_type_exists(
                    $companies_pkey, $users_pkey, $customer->{customers_fkey}, 'DELIVERY'
                );
                say "customer 2 " . Dumper($customer);
                if($exists == 0) {
                    $customer->{type} = 'DELIVERY';
                    $customer_addresses_pkey = await Engine::Model::Customer::CustomerAddress->new(
                        db => $db
                    )->insert_p(
                        $companies_pkey, $users_pkey, $customer
                    );
                }
            }
        }
        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;


    my $result->{data} = $customer_addresses_pkey;
    $result->{status} = $err ? $err : 'success';
    return $result;
}

async sub load_invoice_address_p($self, $companies_pkey, $users_pkey, $customers_pkey) {

    my $result = Engine::Model::Customer::CustomerAddress->new(
        db => $self->pg->db
    )->load_invoice_address_p(
        $customers_pkey
    );

    return $result;
}

async sub load_delivery_address_p($self, $companies_pkey, $users_pkey, $customer_addresses_pkey) {

    my $result = Engine::Model::Customer::CustomerAddress->new(
        db => $self->pg->db
    )->load_delivery_address_p(
        $customer_addresses_pkey
    );

    return $result;
}

async sub load_delivery_address_list_p($self, $companies_pkey, $users_pkey, $customers_pkey) {

    my $result = Engine::Model::Customer::CustomerAddress->new(
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
         my $customers = await Engine::Model::Customer::Customers->new(
             db => $self->pg->db
         )->load_customer(
             $companies_pkey, $customer
         );

         $result = Engine::Model::Customer::CustomerAddress->new(
             db => $self->pg->db
         )->load_delivery_address_list_p(
             $customers->{customers_pkey}
         );
     };
     $err = $@ if $@;


     return $result;
 }

async sub load_delivery_address_from_company_list($self, $companies_pkey, $users_pkey) {

    my $stmt = qq{
        SELECT customer_addresses.* FROM customer_addresses, customers
            WHERE customers_pkey = customers_fkey AND companies_fkey = ?
    };

    my $result = $self->pg->db->query($stmt,($companies_pkey));

    my $hash;
    $hash = $result->hashes if $result and $result->rows();

    return $hash;
}
1;