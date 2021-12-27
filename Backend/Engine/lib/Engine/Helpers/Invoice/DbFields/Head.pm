package Engine::Helpers::Invoice::DbFields::Head;
use Mojo::Base -base, -signatures;


sub upsert_fields ($self) {
    my @fields = (
        'customers_fkey', 'users_fkey', 'companies_fkey', 'orderdate', 'deliverydate', 'orderno', 'invoicedays_fkey'
    );

    return \@fields;
}

1;