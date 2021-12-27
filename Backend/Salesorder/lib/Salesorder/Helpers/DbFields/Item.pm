package Salesorder::Helpers::DbFields::Item;
use Mojo::Base -base, -signatures;


sub upsert_fields ($self) {
    my @fields = (
        'users_fkey', 'salesorders_fkey', 'quantity', 'price', 'customer_addresses_fkey', 'stockitem', 'description', 'vat', 'discount', 'deliverydate', 'unit', 'account', 'vat_txt', 'discount_txt'
    );

    return \@fields;
}
1;