package venditabant::Helpers::Salesorders;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use venditabant::Model::SalesorderHead;
use venditabant::Model::Counter;
use venditabant::Model::SalesorderItem;

use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $users_pkey, $data) {

    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $sohead = venditabant::Model::SalesorderHead->new(db => $db);

        my $orderno = await $sohead->get_open_so(
            $companies_pkey, $data->{customer}
        );


        if( !defined $orderno or $orderno == 0) {
            my $counter = venditabant::Model::Counter->new(db => $db);
            $orderno = await $counter->nextid(
                $companies_pkey, $users_pkey, 'salesorder'
            );
        }

        say "Orderno 2 " . Dumper($orderno);
        $data->{orderno} = $orderno;
        my $salesorderhead_pkey = await $sohead->upsert(
            $companies_pkey, $users_pkey, $data
        );

        say "salesorderhead_pkey 1 " . Dumper($salesorderhead_pkey);

        await venditabant::Model::SalesorderItem->new(
            db => $db
        )->upsert(
            $companies_pkey, $salesorderhead_pkey, $users_pkey, $data
        );

        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;

    return $err ? $err : 'success';
}
1;