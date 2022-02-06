package Invoice::PreCheck::Recipients;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'pg';

async sub find_recipients ($self, $invoice_pkey, $data) {

    my $stmt = qq {
        SELECT b.insby as creator, mailadresses FROM customer_addresses a JOIN invoice b
            ON a.customers_fkey = b.customers_fkey
        AND invoice_pkey = ? AND a.type = 'INVOICE'
    };

    my $result = $self->pg->db->query($stmt,($invoice_pkey));

    my $hash;
    $hash = $result->hash if defined $result and $result->rows() > 0;

    if(defined $hash) {
        my @mailadresses;
        if(index($hash->{mailadresses},',') > -1) {
            @mailadresses = split(',',$hash->{mailadresses});
        }
        if(index($hash->{mailadresses},';') > -1) {
            @mailadresses = split(',',$hash->{mailadresses});
        }

        if(scalar @mailadresses) {
            foreach my $address (@mailadresses){
                push @{$data->{customer}->{mailadresses}}, $address;
            }
        } else {
            push @{$data->{customer}->{mailadresses}}, $hash->{mailadresses};
        }

        if(index($hash->{creator},'@') > -1) {
            push @{$data->{customer}->{mailadresses}}, $hash->{creator};
        }

        push @{$data->{customer}->{mailadresses}}, 'admin@venditabant.net';
    }

    return $data;
}
1;