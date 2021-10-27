package venditabant::Helpers::Invoice::Invoices;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;


use Data::Dumper;

has 'pg';


async sub load_invoice_list ($self, $companies_pkey, $users_pkey, $data) {

    my $result;
    my $err;
    eval {
        $result = venditabant::Model::InvoiceHead->new(
            db => $self->pg->db
        )->load_invoice_list(
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;
    $self->capture_message(
        $self->pg, '',
        'venditabant::Helpers::Salesorder::Salesorders', 'load_list_p', $err
    ) if $err;

    return $result;
}

1;