package Engine::Precheck::Salesorder::Close;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Log::Log4perl qw(:easy);

has 'pg';

async sub find_customers_fkey($self, $data) {

    my $log = Log::Log4perl->get_logger();
    $log->debug(
        "Engine::Precheck::Salesorder::Close find_customers_fkey start" . Dumper($data)
    );

    $data->{customers_fkey} = 0 unless exists $data->{customers_fkey} and $data->{customers_fkey} > 0;
    if($data->{customer_addresses_fkey} > 0 and $data->{customers_fkey} == 0) {
        $data->{customers_fkey} = $self->pg->db->select(
            'customer_addresses',
            ['customers_fkey'],
            {
                customer_addresses_pkey => $data->{customer_addresses_fkey},
            }
        )->hash->{customers_fkey};
    } else {
        $log->error(
            "Engine::Precheck::Salesorder::Close find_customers_fkey customer_addresses_pkey is missing"
        );
    }
    $log->debug(
        "Engine::Precheck::Salesorder::Close find_customers_fkey end" . Dumper($data)
    );

    return $data;
}
1;