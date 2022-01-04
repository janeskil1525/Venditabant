package Engine::Precheck::History::Data;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Log::Log4perl qw(:easy);

has 'pg';

async sub load_user($self, $data) {

    my $users_pkey = 0;
    $users_pkey = $data->{users_fkey} if exists $data->{users_fkey};
    $users_pkey = $data->{users_pkey} if exists $data->{users_pkey};

    my $userid = $self->pg->db->select(
        'users', ['userid'],
            {
                users_pkey => $users_pkey
            }
    )->hash->{userid};

    $data->{history}->{userid} = $userid;
    return $data;
}

async sub load_customer($self, $data) {

    my $customers_pkey = 0;
    $customers_pkey = $data->{customers_fkey} if exists $data->{customers_fkey};
    $customers_pkey = $data->{customers_pkey} if exists $data->{customers_pkey};

    my $customer = $self->pg->db->select(
        'customers', ['customer'],
        {
            customers_pkey => $customers_pkey
        }
    )->hash->{customer};

    $data->{history}->{customer} = $customer;
    return $data;
}

async sub load_company($self, $data) {

    my $companies_pkey = 0;
    $companies_pkey = $data->{companies_fkey} if exists $data->{companies_fkey};
    $companies_pkey = $data->{companies_pkey} if exists $data->{companies_pkey};

    my $company = $self->pg->db->select(
        'companies', ['company'],
        {
            companies_pkey => $companies_pkey
        }
    )->hash->{company};

    $data->{history}->{company} = $company;
    return $data
}
1;