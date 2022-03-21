package Invoice::PreCheck::Recipients;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;

has 'pg';

async sub find_recipients ($self, $data) {

    my $invoice_fkey = $data->{invoice_fkey};

    my $stmt = qq {
        SELECT b.insby as creator, mailadresses, a.name, a.address1, a.address2, a.address3, a.zipcode, a.city,
            a.reference, a.comment
        FROM customer_addresses a JOIN invoice b
            ON a.customers_fkey = b.customers_fkey
        AND invoice_pkey = ? AND a.type = 'INVOICE'
    };

    my $result = $self->pg->db->query($stmt,($invoice_fkey));

    my $hash;
    $hash = $result->hash if defined $result and $result->rows() > 0;

    if(defined $hash) {
        my @mailadresses;

        my @keys = keys %{ $hash };
        foreach my $key (@keys) {
            $data->{customer}->{$key} = $hash->{$key};
        }

        if(index($hash->{mailadresses},',') > -1) {
            @mailadresses = split(',',$hash->{mailadresses});
        }
        if(index($hash->{mailadresses},';') > -1) {
            @mailadresses = split(',',$hash->{mailadresses});
        }

        if(scalar @mailadresses) {
            foreach my $address (@mailadresses){
                push @{$data->{customer}->{recipients}}, $address;
            }
        } else {
            push @{$data->{customer}->{recipients}}, $hash->{mailadresses};
        }

        if(index($hash->{creator},'@') > -1) {
            push @{$data->{customer}->{recipients}}, $hash->{creator};
        }

        push @{$data->{customer}->{recipients}}, 'admin@venditabant.net';
    }

    return $data;
}
1;