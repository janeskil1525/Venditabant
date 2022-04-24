package Customers::Helpers::Customer;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Customers::Model::Customers;
use Customers::Model::Counter;

has 'pg';

sub get_new_cust_id($self, $companies_pkey, $users_pkey) {
    my $nextid = Customers::Model::Counter->new(
        db => $self->pg->db
    )->nextid(
        $companies_pkey, $users_pkey, 'customers'
    );
    $nextid .= '00000000000';
    my $custid = substr($nextid,0,10);

    return $custid;
}

sub invoice_customer ($self, $customer_pkey) {

    my $result = $self->pg->db->select(
        ['customers', ['customer_addresses',  customers_fkey => 'customers_pkey']],
            [
                'customers_pkey', 'customer_addresses_pkey', 'customer', 'name', 'address1', 'address2',
                'address3', 'city', 'zipcode', 'comment', 'mail_invoice', 'reference', 'homepage', 'languages_fkey',
                'active', 'blocked'
            ],
            {
                customers_pkey => $customer_pkey,
                type           => 'INVOICE'
            }
    );

    my $hash;
    $hash = $result->hash if defined $result and $result->rows() > 0;

    return $hash;
}

async sub load_list ($self, $companies_pkey, $users_pkey) {

    my $load_stmt = qq {
        SELECT customers_pkey, customer, name, registrationnumber, homepage, phone,
            (SELECT pricelist FROM pricelists WHERE pricelists_pkey = pricelists_fkey) as pricelist,
            comment, languages_fkey, active, blocked
            FROM customers
        WHERE companies_fkey = ?
    };

    my $err;
    my $hashes;
    eval {
        my $list = $self->pg->db->query($load_stmt, ($companies_pkey));
        $hashes = $list->hashes if $list->rows > 0;
    };
    $err = $@ if $@;
    say "error '$err'" if $err;

    return $hashes;
}

async sub upsert_p ($self, $companies_pkey, $users_pkey, $customers ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $customers_pkey = Customers::Model::Customers->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $customers
        );
        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Customers::Customers', 'upsert', $err
    ) if $err;

    return $err ? $err : 'success';
}

sub upsert ($self, $companies_pkey, $users_pkey, $customers ) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $customers_pkey;
    my $err;
    eval {
        $customers_pkey = Customers::Model::Customers->new(
            db => $db
        )->upsert(
            $companies_pkey, $users_pkey, $customers
        );
        $tx->commit();
    };
    $err = $@ if $@;

    return $customers_pkey;
}
1;