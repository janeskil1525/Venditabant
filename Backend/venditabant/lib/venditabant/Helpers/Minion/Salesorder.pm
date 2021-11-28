package venditabant::Helpers::Minion::Salesorder;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Invoice::From::Salesorder;

use Data::Dumper;

has 'pg';

async sub init($self, $minion) {

    $minion->add_task(create_invoice_from_salesorder => \&_create_invoice_from_salesorder);
}

sub _create_invoice_from_salesorder($job, $salesorder) {

    venditabant::Helpers::Invoice::From::Salesorder->new(
            pg => $job->app->pg
    )->convert(
            $salesorder->{companies_pkey},
            $salesorder->{users_pkey},
            $salesorder->{customers_fkey},
            $salesorder->{salesorders_pkey},
    )->then(sub ($res) {

        my $result = "Company " . $salesorder->{companies_pkey} .
            " User " . $salesorder->{users_pkey} . " Salesorder " . $salesorder->{salesorders_pkey} .
            " Created sucessfully";

        $job->finish({ status => $result});

    })->catch(sub($err) {
        my $mess = "Company " . $salesorder->{companies_pkey} .
            " User " . $salesorder->{users_pkey} . " Salesorder " .
            $salesorder->{salesorders_pkey} . ' ' . $err;
        venditabant::Helpers::Sentinel::Sentinelsender->new()->capture_message(
            $job->app->pg, 'venditabant',
            'venditabant::Helpers::Minion::Salesorder', '_convert', $mess
        ) if $err;

        $job->finish({ status => $err});

    })->wait;

}
1;