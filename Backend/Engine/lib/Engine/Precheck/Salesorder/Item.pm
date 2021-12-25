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

    $data = await $prep->prepare_item(
        $data->{companies_fkey},
        $data->{users_fkey},
        $data
    );

    return $data;
}


1;