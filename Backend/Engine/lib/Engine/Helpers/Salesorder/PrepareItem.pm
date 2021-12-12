package Engine::Helpers::Salesorder::PrepareItem;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Stockitems;
use venditabant::Helpers::Discount::Calculate;
use venditabant::Helpers::Vat::Calculate;

use Data::Dumper;

has 'pg';

async sub prepare_item($self, $companies_pkey, $users_pkey, $stockitems_pkey, $data) {

    my $err;
    my $stockitem;
    eval {
        $stockitem = await venditabant::Model::Stockitems->new(
            db => $self->pg->db
        )->load_complete_item(
            $companies_pkey, $users_pkey, $stockitems_pkey
        );

        say "load_complete_item " . Dumper($stockitem);

        $data->{description} = $stockitem->{description} unless exists $data->{description};
        $data->{unit} = $stockitem->{units} unless exists $data->{unit};
        $data->{account} = $stockitem->{accounts} unless exists $data->{account};
        $data->{productgroup} = $stockitem->{productgroup} unless exists $data->{productgroup};

        my $discount = await venditabant::Helpers::Discount::Calculate->new(
            pg => $self->pg
        )->calculate_item_discount(
            $companies_pkey,
            $users_pkey,
            $data->{customers_fkey},
            $stockitems_pkey,
            $stockitem->{productgroups_fkey},
            $data->{quantity},
            $data->{price}
        );

        $data->{discount} = $discount->{discount};
        $data->{discount_txt} = $discount->{discount_txt};

        my $vat = await venditabant::Helpers::Vat::Calculate->new(
            pg => $self->pg
        )->calculate(
            $companies_pkey, $stockitem->{vat_fkey}, $data->{quantity}, $data->{price}
        );

        $data->{vat} = $vat->{vat_sum};
        $data->{vat_txt} = $vat->{vat_txt};

    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Salesorder::PrepareItem', 'prepare_item', $err
    ) if $err;

    return $data;

}
1;