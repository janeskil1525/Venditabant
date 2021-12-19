package Engine::Precheck::Salesorder::Item;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Log::Log4perl qw(:easy);

use Engine::Precheck::Salesorder::PrepareItem;

has 'pg';

async sub precheck ($self, $data) {

    my $prep = Engine::Precheck::Salesorder::PrepareItem->new(
        pg => $self->pg
    );

    my $length = scalar @{$data->{items}};
    for(my $i = 0; $i < $length; $i++) {
        @{$data->{items}}[$i]->{customer_addresses_fkey} = $data->{customer_addresses_pkey}
            if exists $data->{customer_addresses_pkey};
        @{$data->{items}}[$i]->{customer_addresses_fkey} = $data->{customer_addresses_fkey}
            if exists $data->{customer_addresses_fkey};

        @{$data->{items}}[$i] = await $prep->prepare_item(
            $data->{companies_fkey},
            $data->{users_fkey},
            @{$data->{items}}[$i]->{stockitems_fkey},
            @{$data->{items}}[$i]
        );
    }

    return $data;
}


1;