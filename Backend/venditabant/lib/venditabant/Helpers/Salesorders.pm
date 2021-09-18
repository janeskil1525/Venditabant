package venditabant::Helpers::Salesorders;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use venditabant::Model::SalesorderHead;
use venditabant::Model::Counter;
use Data::Dumper;

has 'pg';

async sub upsert ($self, $companies_pkey, $users_pkey, $data) {
    my $db = $self->pg->db;
    my $tx = $db->begin();

    my $err;
    eval {
        my $sohead = venditabant::Model::SalesorderHead->new(db => $db);

        my $orderno = wait $sohead->get_open_so(
            $companies_pkey, $data->{customer}
        );

        if( !defined $orderno) {
            $orderno = venditabant::Model::Counter->new(
                pg => $self->pg
            )->nextid(
                $companies_pkey, $users_pkey, 'salesorder'
            );
        }

        $data->{orderno} = $orderno;
        my $salesorderhead_pkey = $sohead->upsert(
            $companies_pkey, $users_pkey, $data
        );

        $tx->commit();
    };
    $err = $@ if $@;
    say "error '$err'" if $err;

    return $err ? $err : 'success';
}
1;