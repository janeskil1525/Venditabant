package venditabant::Helpers::Discount::Discounts;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Discount::Stockitem;
use venditabant::Model::Discount::Productgroups;
use venditabant::Model::Discount::Customer;

use Data::Dumper;

has 'pg';

async sub save_stockitem_discount($self, $companies_pkey, $users_pkey, $data) {

    my $err;
    my $result;

    eval {
        $result = await venditabant::Model::Discount::Stockitem->new(
            db => $self->pg->db
        )->upsert(
            $companies_pkey, $users_pkey, $data
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Discount::Discounts', 'save_stockitem_discount', $err
    ) if $err;

    return $err ? $err : 'success';
}

async sub load_list_stockitem_discount($self, $companies_pkey, $users_pkey, $customers_fkey) {

    my $result;
    my $err;

    eval {
        $result = await venditabant::Model::Discount::Stockitem->new(
            db => $self->pg->db
        )->load_list(
            $companies_pkey, $users_pkey, $customers_fkey
        );
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Discount::Discounts', 'load_list_stockitem_discount', $err
    ) if $err;

    return $result;
}
1;