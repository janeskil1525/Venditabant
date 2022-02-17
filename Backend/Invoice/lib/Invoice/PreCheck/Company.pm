package Invoice::PreCheck::Company;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'pg';

async sub load_company ($self, $invoice_fkey, $data) {

    my $stmt = qq {
        SELECT a.company, a.name, a.homepage, a.phone, a.address1, a.address2, a.address3, a.zipcode, a.city,
            a.invoiceref, a.email, a.tin, a.invoicecomment, a.companies_pkey
        FROM companies as a JOIN invoice as b ON b.companies_fkey = a.companies_pkey AND b.invoice_pkey = ?
    };

    my $result = $self->pg->db->query(
        $stmt,($invoice_fkey)
    );

    my $hash;
    $hash = $result->hash if $result and $result->rows() > 0;

    return $data unless exists $hash->{company};

    $data->{history}->{company} = $hash->{company};
    $data->{company} = $hash;

    return $data;
}
1;