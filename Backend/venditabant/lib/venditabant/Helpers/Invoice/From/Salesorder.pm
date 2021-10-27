package venditabant::Helpers::Invoice::From::Salesorder;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Salesorder::Salesorders;
use venditabant::Model::InvoiceHead;
use venditabant::Model::InvoiceItem;

use Data::Dumper;

has 'pg';

async sub convert($self, $companies_pkey, $users_pkey, $salesorders_pkey) {

    my $order = venditabant::Helpers::Salesorder::Salesorders->new(
        pg => $self->pg
    )->load_salesorder_full($companies_pkey, $users_pkey, $salesorders_pkey);

    my $db = $self->pg->db;
    my $tx = $db->begin();
    my $err;
    if($order) {
        eval {
            my $invoicehead = await $self->map_invoicehead($companies_pkey, $users_pkey, $order);
            my $invoice_pkey = await venditabant::Model::InvoiceHead->new(
                db => $db
            )->insert(
                $companies_pkey, $users_pkey, $invoicehead
            );
            foreach my $item (@{$order->{items}}) {
                my $invoiceitem = $self->map_invoiceitem($companies_pkey, $users_pkey, $invoice_pkey, $item);
                await venditabant::Model::InvoiceItem->new(
                    db => $db
                )->insert(
                    $companies_pkey, $users_pkey, $invoiceitem
                );
            }
            $tx->commit();
        };
        $err = $@ if $@;
        $self->capture_message (
            $self->pg, '',
            'venditabant::Helpers::Invoice::From::Salesorder', 'convert', $err
        ) if $err;
    }
}

async sub map_invoiceitem ($self, $companies_pkey, $users_pkey, $invoice_pkey, $item) {

    my $item->{invoice_fkey} = $invoice_pkey;
    $item->{stockitems_fkey} = $item->{stockitems_fkey};
    $item->{quantity} = $item->{quantity};
    $item->{price} = $item->{price};
    $item->{vat} = $item->{vat};
    $item->{vatsum} = $item->{vatsum};
    $item->{netsum} = $item->{netsum};
    $item->{total} = $item->{total};

    return $item;
}

async sub map_invoicehead($self, $companies_pkey, $users_pkey, $order) {

    my $counter = venditabant::Model::Counter->new(db => $db);
    my $invoiceno = await $counter->nextid(
        $companies_pkey, $users_pkey, 'invoice'
    );
    my $invoicehead->{invoiceno} = $invoiceno;
    $invoicehead->{customers_fkey} = $order->{customers_fkey};
    $invoicehead->{companies_fkey} = $companies_pkey;
    $invoicehead->{invoicedate} = $order->{invoicedate};
    $invoicehead->{paydate} = $order->{paydate};
    $invoicehead->{address1} = $order->{address1};
    $invoicehead->{address2} = $order->{address2};
    $invoicehead->{address3} = $order->{address3};
    $invoicehead->{city} = $order->{city};
    $invoicehead->{country} = $order->{country};
    $invoicehead->{mailaddresses} = $order->{mailaddresses};
    $invoicehead->{vatsum} = $order->{vatsum};
    $invoicehead->{netsum} = $order->{netsum};
    $invoicehead->{total} = $order->{total};
    $invoicehead->{salesorder_fkey} = $order->{salesorder_pkey};
    $invoicehead->{invoicedays} = $order->{invoicedays};

    return $invoicehead;
}
1;