package Salesorder::Precheck::PrepareItem;
use Mojo::Base -base, -signatures, -async_await;

use Salesorder::Model::Stock::Stockitems;;
use Salesorder::Helpers::Discount::Calculate;
use Salesorder::Helpers::Vat::Calculate;

use Data::Dumper;

has 'pg';

async sub prepare_item($self, $companies_pkey, $users_pkey, $data) {

    my $err;
    my $stockitem;
    my $log = Log::Log4perl->get_logger();
    eval {
        $stockitem = await Engine::Model::Stock::Stockitems->new(
            db => $self->pg->db
        )->load_complete_item(
            $companies_pkey, $users_pkey, $data->{stockitems_fkey}
        );

        $data->{stockitem} = $stockitem->{stockitem} unless exists $data->{stockitem};
        $data->{description} = $stockitem->{description} unless exists $data->{description};
        $data->{unit} = $stockitem->{units} unless exists $data->{unit};
        $data->{account} = $stockitem->{accounts} unless exists $data->{account};
        $data->{productgroup} = $stockitem->{productgroup} unless exists $data->{productgroup};

        my $discount = await Engine::Helpers::Discount::Calculate->new(
            pg => $self->pg
        )->calculate_item_discount(
            $companies_pkey,
            $users_pkey,
            $data->{customers_fkey},
            $data->{stockitems_fkey},
            $stockitem->{productgroups_fkey},
            $data->{quantity},
            $data->{price}
        );

        $data->{discount} = $discount->{discount};
        $data->{discount_txt} = $discount->{discount_txt};

        my $vat = await Engine::Helpers::Vat::Calculate->new(
            pg => $self->pg
        )->calculate(
            $companies_pkey, $stockitem->{vat_fkey}, $data->{quantity}, $data->{price}
        );

        $data->{vat} = $vat->{vat_sum};
        $data->{vat_txt} = $vat->{vat_txt};

    };
    $err = $@ if $@;
    $log->error(
        "Engine::Precheck::Salesorder::PrepareItem " . $err
    ) if $err;

    return $data;

}
1;