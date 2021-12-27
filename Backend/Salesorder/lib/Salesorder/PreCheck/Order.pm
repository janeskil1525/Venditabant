package Salesorder::PreCheck::Order;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Log::Log4perl qw(:easy);

has 'pg';

async sub find_open_salesorder($self, $data) {

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Precheck::Salesorder::Precheck find_open_salesorder start" . Dumper($data)
    );

    $data->{salesorders_pkey} = 0 unless exists $data->{salesorders_pkey} and $data->{salesorders_pkey} > 0;
    if($data->{salesorders_pkey} == 0) {
        my $result = $self->pg->db->select(
            'salesorders', ['salesorders_pkey'],
            {
                companies_fkey => $data->{companies_fkey},
                customers_fkey => $data->{customers_fkey},
                open           => 1,
            }
        );

        my $hash;
        $hash = $result->hash if $result and $result->rows > 0;

        $data->{salesorders_pkey} = $hash->{salesorders_pkey} if exists $hash->{salesorders_pkey};
    }

    $log->debug(
        "Engine::Precheck::Salesorder::Precheck find_open_salesorder end" . Dumper($data)
    );
    return $data;
}

async sub find_wf_id($self, $data) {

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Precheck::Salesorder::Order find_wf_id start" . Dumper($data)
    );

    my $salesorders_pkey = 0;
    $salesorders_pkey = $data->{salesorders_pkey} if exists $data->{salesorders_pkey} and $data->{salesorders_pkey} > 0;
    $salesorders_pkey = $data->{salesorders_fkey} if exists $data->{salesorders_fkey} and $data->{salesorders_fkey} > 0;

    if ($salesorders_pkey > 0) {
        $data->{workflow_id} = $self->pg->db->select(
            'workflow_salesorders', ['workflow_id'],
                {
                    salesorders_pkey => $salesorders_pkey
                }
        )->hash->{workflow_id};
    } else {
        $data->{workflow_id} = 0;
    }

    $log->debug(
        "Engine::Precheck::Salesorder::Order find_wf_id end" . Dumper($data)
    );

    return $data;
}

async sub find_customers_fkey($self, $data) {

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Precheck::Salesorder::Precheck find_customers_fkey start" . Dumper($data)
    );

    $data->{customers_fkey} = 0 unless exists $data->{customers_fkey} and $data->{customers_fkey} > 0;
    if($data->{customer_addresses_pkey} > 0 and $data->{customers_fkey} == 0) {
        $data->{customers_fkey} = $self->pg->db->select(
            'customer_addresses',
            ['customers_fkey'],
            {
                customer_addresses_pkey => $data->{customer_addresses_pkey},
            }
        )->hash->{customers_fkey};
    } else {
        $log->debug(
            "Engine::Precheck::Salesorder::Order find_customers_fkey customer_addresses_pkey is missing"
        );
    }
    $log->debug(
        "Engine::Precheck::Salesorder::Order find_customers_fkey end" . Dumper($data)
    );

    return $data;
}

async sub find_invoicedays_fkey($self, $data) {

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Precheck::Salesorder::Order find_invoicedays_fkey start" . Dumper($data)
    );

    $data->{invoicedays_fkey} = 0 unless exists $data->{invoicedays_fkey} and $data->{invoicedays_fkey} > 0;
    if( $data->{invoicedays_fkey} == 0) {
        $data->{invoicedays_fkey} = $self->pg->db->select(
            'customer_addresses',
            ['invoicedays_fkey'],
            {
                customers_fkey => $data->{customers_fkey},
                type           => 'INVOICE',
            }
        )->hash->{invoicedays_fkey};
    } else {
        $log->debug(
            "Engine::Precheck::Salesorder::Order find_customers_fkey customer_addresses_pkey is missing"
        );
    }
    $log->debug(
        "Engine::Precheck::Salesorder::Order find_customers_fkey end" . Dumper($data)
    );

    return $data;
}
1;