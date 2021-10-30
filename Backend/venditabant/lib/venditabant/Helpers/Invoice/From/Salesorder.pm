package venditabant::Helpers::Invoice::From::Salesorder;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Salesorder::Salesorders;
use venditabant::Model::SalesorderHead;
use venditabant::Model::InvoiceHead;
use venditabant::Model::InvoiceItem;
use venditabant::Model::InvoiceStatus;

use DateTime;
use Data::Dumper;

has 'pg';

async sub convert($self, $companies_pkey, $users_pkey, $salesorders_pkey) {

    my $order = await venditabant::Helpers::Salesorder::Salesorders->new(
        pg => $self->pg
    )->load_salesorder_full($companies_pkey, $users_pkey, $salesorders_pkey);

    my $db = $self->pg->db;
    my $tx = $db->begin();
    my $err;
    if($order) {
        eval {
            my $invoicehead = await $self->map_invoicehead($companies_pkey, $users_pkey, $order, $db);
            my $invoice_pkey = await venditabant::Model::Invoice::InvoiceHead->new(
                db => $db
            )->insert(
                $companies_pkey, $users_pkey, $invoicehead
            );
            foreach my $item (@{$order->{items}}) {
                my $invoiceitem = await $self->map_invoiceitem($companies_pkey, $users_pkey, $invoice_pkey, $item);
                await venditabant::Model::Invoice::InvoiceItem->new(
                    db => $db
                )->insert(
                    $companies_pkey, $users_pkey, $invoiceitem
                );
            }
            await venditabant::Model::Invoice::InvoiceStatus->new(
                db => $db
            )->insert(
                $companies_pkey, $users_pkey, $invoice_pkey,'SENT'
            );

            await venditabant::Model::SalesorderHead->new(
                db => $db
            )->invoice($salesorders_pkey);

            $tx->commit();
        };
        $err = $@ if $@;
        $self->capture_message (
            $self->pg, '',
            'venditabant::Helpers::Invoice::From::Salesorder', 'convert', $err
        ) if $err;
    }
}

async sub map_invoiceitem ($self, $companies_pkey, $users_pkey, $invoice_pkey, $item_in) {

    my $item->{invoice_fkey} = $invoice_pkey;
    $item->{stockitems_fkey} = $item_in->{stockitems_fkey};
    $item->{quantity} = $item_in->{quantity} ? $item_in->{quantity} : 0;
    $item->{price} = $item_in->{price} ? $item_in->{price} : 0;
    $item->{vat} = $item_in->{vat} ? $item_in->{vat} : 0;
    $item->{vatsum} = $item_in->{vatsum} ? $item_in->{vatsum} : 0;
    $item->{netsum} = $item_in->{netsum} ? $item_in->{netsum} : 0;
    $item->{total} = $item_in->{total} ? $item_in->{total} : 0;

    return $item;
}

async sub map_invoicehead($self, $companies_pkey, $users_pkey, $order, $db) {

    $order->{salesorder}->{invoicedays} = 30 unless $order->{salesorder}->{invoicedays};
    my $now = DateTime->now();
    my $counter = venditabant::Model::Counter->new(db => $db);
    my $invoiceno = await $counter->nextid(
        $companies_pkey, $users_pkey, 'invoice'
    );
    my $invoicehead->{invoiceno} = $invoiceno;
    $invoicehead->{customers_fkey} = $order->{salesorder}->{customers_fkey};
    $invoicehead->{companies_fkey} = $companies_pkey;
    $invoicehead->{invoicedate} = $now;

    my $paydate = $now;
    $paydate = $paydate->add(days => $order->{salesorder}->{invoicedays});
    $invoicehead->{paydate} = $paydate;
    $invoicehead->{address1} = $order->{invaddress}->{address1};
    $invoicehead->{address2} = $order->{invaddress}->{address2};
    $invoicehead->{address3} = $order->{invaddress}->{address3} ? $order->{invaddress}->{address3} : '';
    $invoicehead->{city} = $order->{invaddress}->{city} ? $invoicehead->{city} = $order->{invaddress}->{city} : '';
    $invoicehead->{zipcode} = $order->{invaddress}->{zipcode} ? $order->{invaddress}->{zipcode} : '';
    $invoicehead->{country} = $order->{invaddress}->{country} ? $order->{invaddress}->{country} : '';
    $invoicehead->{mailadresses} = $order->{invaddress}->{mailadresses};
    $invoicehead->{vatsum} = $order->{salesorder}->{vatsum} ? $order->{salesorder}->{vatsum} : 0;
    $invoicehead->{netsum} = $order->{salesorder}->{netsum} ? $order->{salesorder}->{netsum} : 0;
    $invoicehead->{total} = $order->{salesorder}->{total} ? $order->{salesorder}->{total} : 0;
    $invoicehead->{salesorders_fkey} = $order->{salesorder}->{salesorders_pkey};
    $invoicehead->{invoicedays} = $order->{salesorder}->{invoicedays};

    return $invoicehead;
}
1;