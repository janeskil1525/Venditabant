package venditabant::Helpers::Minion::Salesorder;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Invoice::From::Salesorder;

use Data::Dumper;

has 'pg';

async sub init($self, $minion) {

    $minion->add_task(create_invoice_from_salesorder => \&_create_invoice_from_salesorder);
}

sub _create_invoice_from_salesorder($job, $salesorder) {

    create_invoice_from_salesorder(
        $job->app->pg, $salesorder
    )->then(sub ($res) {

        my $result = "Company " . $salesorder->{companies_pkey} .
            " User " . $salesorder->{users_pkey} . " Salesorder " . $salesorder->{salesorders_pkey} .
            " Created sucessfully";

        $job->finish({ status => $result});

    })->catch(sub($err) {
        my $mess = "Company " . $salesorder->{companies_pkey} .
            " User " . $salesorder->{users_pkey} . " Salesorder " .
            $salesorder->{salesorders_pkey} . ' ' . $err;
        Sentinel::Helpers::Sentinelsender->new()->capture_message(
            $job->app->pg, 'venditabant',
            'venditabant::Helpers::Minion::Salesorder', '_convert', $mess
        ) if $err;

        $job->finish({ status => $err});

    })->wait;


}

async sub create_invoice_from_salesorder($db, $salesorder) {

    return venditabant::Helpers::Invoice::From::Salesorder->new(
        pg => $db
    )->convert(
        $salesorder->{companies_pkey},
        $salesorder->{users_pkey},
        $salesorder->{customers_fkey},
        $salesorder->{salesorders_pkey},
    );
}

async sub create_invoice_from_salesorder_test($self, $pg, $salesorder) {

    return create_invoice_from_salesorder(
        $pg, $salesorder
    );

}
1;