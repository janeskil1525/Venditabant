package Engine::Helpers::History::Precheck;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Log::Log4perl qw(:easy);

has 'pg';

async sub load_user($self, $data) {

    my $userid = $self->pg->db->select(
        'users', ['userid'],
            {
                users_pkey => $data->{users_fkey}
            }
    )->hash->{userid};

    $data->{history}->{userid} = $userid;
    return $data;
}

async sub load_customer($self, $data) {

    my $customer = $self->pg->db->select(
        'customers', ['customer'],
        {
            customers_pkey => $data->{customers_fkey}
        }
    )->hash->{customer};

    $data->{history}->{customer} = $customer;
    return $data;
}

async sub load_company($self, $data) {

    my $company = $self->pg->db->select(
        'companies', ['company'],
        {
            companies_pkey => $data->{companies_fkey}
        }
    )->hash->{company};

    $data->{history}->{company} = $company;
    return $data
}
1;