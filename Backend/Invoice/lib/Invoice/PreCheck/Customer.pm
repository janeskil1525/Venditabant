package Invoice::PreCheck::Customer;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'pg';


async sub find_customer($self, $data) {

    my $invoice_fkey = $data->{invoice_fkey};

    my $stmt = qq {
        SELECT customers_pkey, a.name, a.companies_fkey, a.languages_fkey FROM customers a JOIN invoice b
        ON customers_pkey = customers_fkey AND invoice_pkey = ?
    };

    my $result = $self->pg->db->query($stmt,($invoice_fkey));

    my $hash;
    $hash = $result->hash if defined $result and $result->rows() > 0;

    if(defined $hash) {
        $data->{customer}->{name} = $hash->{name};
        $data->{customer}->{companies_fkey} = $hash->{companies_fkey};
        $data->{customer}->{languages_fkey} = $hash->{languages_fkey};
    }

    return $data;
}

1;