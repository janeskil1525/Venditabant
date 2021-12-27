package Salesorder::PreCheck::Item;
use Mojo::Base -base, -signatures, -async_await;

use Data::Dumper;
use Log::Log4perl qw(:easy);

use Salesorder::PreCheck::PrepareItem;

has 'pg';

async sub precheck ($self, $data) {

    my $prep = Salesorder::PreCheck::PrepareItem->new(
        pg => $self->pg
    );

    $data = await $prep->prepare_item(
        $data->{companies_fkey},
        $data->{users_fkey},
        $data
    );

    return $data;
}


1;