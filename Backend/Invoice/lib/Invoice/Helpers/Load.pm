package Invoice::Helpers::Load;
use Mojo::Base -base, -signatures;

use Data::Dumper;

use Invoice::Model::Head;
use Invoice::Model::Item;
use venditabant::Model::Company;
use venditabant::Model::Customer::Customers;

has 'pg';

sub load_invoice_full ($self, $companies_pkey, $users_pkey, $invoice_pkey) {

    my $log = Log::Log4perl->get_logger();

    my $result;
    my $err;
    eval {
        $result->{invoice} = Invoice::Model::Head->new(
            db => $self->pg->db
        )->load_invoice(
            $companies_pkey, $users_pkey, $invoice_pkey
        );
        $result->{items} = Invoice::Model::Item->new(
            db => $self->pg->db
        )->load_items_list (
            $companies_pkey, $users_pkey, $invoice_pkey
        );
        $result->{company} = Invoice::Model::Company->new(
            db => $self->pg->db
        )->load(
            $companies_pkey, $users_pkey
        );
        $result->{customer} = Invoice::Model::Customers->new(
            db => $self->pg->db
        )->load_customer_from_pkey(
            $companies_pkey, $result->{invoice}->{customers_fkey}
        );
    };
    $err = $@ if $@;
    say $err;

    $log->debug("Invoice::Helpers::Load::load_invoice_full '$err' " );

    return $result;
}
1;