package venditabant::Helpers::Invoice::Invoices;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::InvoiceHead;
use venditabant::Model::InvoiceItem;

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

async sub load_invoice($self, $companies_pkey, $users_pkey, $invoice_pkey) {
    my $result;
    my $err;
    eval {
        $result = await venditabant::Model::InvoiceHead->new(
            db => $self->pg->db
        )->load_invoice(
            $companies_pkey, $users_pkey, $invoice_pkey
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Invoice::Invoices', 'load_invoice', $err
    ) if $err;

    return $result;
}

async sub load_invoice_items_list ($self, $companies_pkey, $users_pkey, $salesorders_fkey) {

    my $result;
    my $err;
    eval {
        $result = await venditabant::Model::InvoiceItem->new(
            db => $self->pg->db
        )->load_items_list (
            $companies_pkey, $users_pkey, $salesorders_fkey
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Salesorder::Salesorders', 'load_list_p', $err
    ) if $err;

    return $result;
}


1;