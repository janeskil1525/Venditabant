package Import::Workflow::Action::InvoiceFromSo;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::Exception qw( workflow_error );
use Workflow::History;

use Engine::Model::Counter;

use Import::Helpers::Salesorders;
use Import::Model::Workflow;
use Invoice::Model::Head;
use Invoice::Model::Item;
use Invoice::Helpers::DbFields::Head;

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();

    my $result;
    my $invoice_pkey = 0;
    my $context = $wf->context;
    if($context->param('salesorders_pkey') > 0) {
        $wf->add_history(
            Workflow::History->new({
                action      => "New invoice",
                description => "Invoice will be created for salesorder with key $context->param('salesorders_pkey')",
                user        => $context->param('history')->{userid},
            })
        );

        my $order = Import::Helpers::Salesorders->new(
            pg => $pg
        )->load_salesorder_full(
            $context->param('companies_pkey'), $context->param('users_pkey') , $context->param('salesorders_pkey')
        );

        eval {
            my $db = $pg->db;
            my $tx = $db->begin();

            my $invoicehead = $self->map_invoicehead(
                $context->param('companies_pkey'), $context->param('users_pkey'), $order, $db
            );

            $wf->add_history(
                Workflow::History->new({
                    action      => "New invoiceno",
                    description => "Invoice no $invoicehead->{invoiceno} created",
                    user        => $context->param('history')->{userid},
                })
            );

            $invoice_pkey = Invoice::Model::Head->new(
                db => $db
            )->insert(
                $context->param('companies_pkey'), $context->param('users_pkey'), $invoicehead
            );
            $context->param(invoice_pkey => $invoice_pkey);

            $wf->add_history(
                Workflow::History->new({
                    action      => "New Invoice",
                    description => "Invoice with key $invoice_pkey created",
                    user        => $context->param('history')->{userid},
                })
            );

            foreach my $item (@{$order->{items}}) {
                my $invoiceitem = $self->map_invoiceitem(
                    $context->param('companies_pkey'), $context->param('users_pkey'), $invoice_pkey, $item
                );
                Invoice::Model::Item->new(
                    db => $db
                )->insert(
                    $context->param('companies_pkey'), $context->param('users_pkey'), $invoiceitem
                );
                $wf->add_history(
                    Workflow::History->new({
                        action      => "New Invoice item added",
                        description => "Invoice item stockitem $invoiceitem->{stockitem} created",
                        user        => $context->param('history')->{userid},
                    })
                );
            }

            $wf->add_history(
                Workflow::History->new({
                    action      => "New invoice created",
                    description => "Invoice was created for salesorder with key $context->param('salesorders_pkey')",
                    user        => $context->param('history')->{userid},
                })
            );

            Import::Model::Workflow->new(db => $db)->upsert(
                $context->param('salesorders_pkey'),  $context->param('invoice_pkey'), 'invoice_from_so'
            );

            $tx->commit();

            $context->param(activity => 'create_invoice');
            $context->param(workflow => 'invoice_simple');
            $context->param(type => 'workflow');

            my $payload->{invoice_pkey} = $context->param('invoice_pkey');
            $payload->{companies_pkey} = $context->param('companies_pkey');
            $payload->{users_pkey} = $context->param('users_pkey');
            $context->param(payload => $payload);
            $context->param(context_set => 1);
            $context->param(workflow_id => $wf->id);
        };
        if ( $@ ) {
            say $@;
            workflow_error
                "Cannot create new invoice for salesorder '", $context->param( 'salesorders_pkey' ), "': $@";
        }
    }
    return $result;
}

sub map_invoiceitem ($self, $companies_pkey, $users_pkey, $invoice_pkey, $item_in) {

    my $item->{invoice_fkey} = $invoice_pkey;
    $item->{stockitem} = $item_in->{stockitem};
    $item->{quantity} = $item_in->{quantity} ? $item_in->{quantity} : 0;
    $item->{price} = $item_in->{price} ? $item_in->{price} : 0;
    $item->{vat} = $item_in->{vat} ? $item_in->{vat} : 0;
    $item->{vatsum} = $item_in->{vatsum} ? $item_in->{vatsum} : 0;
    $item->{netsum} = $item_in->{netsum} ? $item_in->{netsum} : 0;
    $item->{total} = $item_in->{total} ? $item_in->{total} : 0;
    $item->{vat_txt} = $item_in->{vat_txt} ? $item_in->{vat_txt} :  ' ';
    $item->{discount_txt} = $item_in->{discount_txt} ? $item_in->{discount_txt} : ' ';
    $item->{discount} = $item_in->{discount} ? $item_in->{discount} : 0;
    $item->{unit} = $item_in->{unit} ? $item_in->{unit} : ' ';
    $item->{account} = $item_in->{account} ? $item_in->{account} : ' ';

    return $item;
}

sub map_invoicehead($self, $companies_pkey, $users_pkey, $order, $db) {

    $order->{salesorder}->{invoicedays} = 30 unless $order->{salesorder}->{invoicedays};
    my $now = DateTime->now();
    my $counter = Engine::Model::Counter->new(db => $db);
    my $invoiceno = $counter->nextid(
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

sub _get_data($self, $context) {

    my $data;
    my $fields = Engine::Helpers::Invoice::DbFields::Head->new->upsert_fields();

    foreach my $field (@{$fields}) {
        $data->{$field} = $context->param($field);
    }

    return $data;
}

sub _get_invoiceno($self, $db, $companies_fkey, $users_fkey) {

    my $invoiceno = Engine::Model::Counter->new(
        db => $db
    )->nextid(
        $companies_fkey, $users_fkey, 'invoice'
    );

    return $invoiceno;
}

sub get_pg($self) {
    return  FACTORY->get_persister( 'ConvertInvoicePersister' )->get_pg();
}
1;