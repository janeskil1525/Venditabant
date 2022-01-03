package Import::Helpers::Salesorders;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

use Engine::Helpers::Customers::Address;
use Salesorder::Model::Item;
use Salesorder::Model::Head;

has 'pg';

sub load_salesorder_full($self, $companies_pkey, $users_pkey, $salesorders_fkey) {
    my $log = Log::Log4perl->get_logger();

    my $order;
    eval {
        $order->{salesorder} = $self->load_salesorder(
            $companies_pkey, $users_pkey, $salesorders_fkey
        );
        $order->{items} = $self->load_salesorder_items_list(
            $companies_pkey, $users_pkey, $salesorders_fkey
        );
        $order->{invaddress} = Engine::Helpers::Customers::Address->new(
            pg => $self->pg
        )->load_invoice_address_p(
            $companies_pkey, $users_pkey, $order->{salesorder}->{customers_fkey}
        );

    };
    $log->error(
        "Import::Helpers::Salesorders load_salesorder_full peky = $salesorders_fkey " . $@
    ) if $@;

    return $order;
}

sub load_salesorder_items_list ($self, $companies_pkey, $users_pkey, $salesorders_fkey) {

    my $log = Log::Log4perl->get_logger();
    my $result;
    my $err;
    eval {
        $result = Salesorder::Model::Item->new(
            db => $self->pg->db
        )->load_items_list (
            $companies_pkey, $users_pkey, $salesorders_fkey
        );
    };
    $err = $@ if $@;
    $log->error(
        'Import::Helpers::Salesorders load_list_p ' . $err
    ) if $err;

    return $result;
}

async sub load_salesorder($self, $companies_pkey, $users_pkey, $salesorders_pkey) {

    my $log = Log::Log4perl->get_logger();
    my $result;
    my $err;
    eval {
        $result = Salesorder::Model::Head->new(
            db => $self->pg->db
        )->load_salesorder (
            $companies_pkey, $users_pkey, $salesorders_pkey
        );
    };
    $err = $@ if $@;
    $$log->error(
        'Import::Helpers::Salesorders load_salesorder ' . $err
    ) if $err;

    return $result;
}

1;