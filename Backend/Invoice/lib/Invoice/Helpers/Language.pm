package Invoice::Helpers::Language;
use Mojo::Base -base, -signatures, -async_await;


has 'pg';

sub get_invoice_language($self, $invoice_pkey) {

    my $stmt = qq{
        SELECT lan FROM languages
            JOIN customers ON languages_pkey = languages_fkey
            JOIN invoice ON customers_fkey = customers_pkey
        WHERE invoice_pkey = ?;
    };

    my $result = $self->pg->db->query($stmt, ($invoice_pkey));

    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;

    return 'swe' unless exists $hash->{lan};
    return $hash->{lan};
}
1;