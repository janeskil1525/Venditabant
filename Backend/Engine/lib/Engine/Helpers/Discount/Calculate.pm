package Engine::Helpers::Discount::Calculate;
use Mojo::Base -base, -signatures, -async_await;

use Engine::Model::Discount::Stockitem;
use Engine::Model::Discount::Productgroups;

use Data::Dumper;

has 'pg';

async sub calculate_item_discount(
    $self, $companies_pkey, $users_pkey, $customers_fkey, $stockitems_fkey,
    $productgroups_fkey, $quantity, $price) {

    my $discount->{discount} = 0;
    $discount->{discount_txt} = ' ';

    my $result = Engine::Model::Discount::Stockitem->new(
        db => $self->pg->db
    )->load_discount(
        $companies_pkey, $users_pkey, $customers_fkey, $stockitems_fkey
    );

    if(!$result->{discount}) {
        $result = Engine::Model::Discount::Productgroups->new(
            db => $self->pg->db
        )->load_discount(
            $companies_pkey, $users_pkey, $customers_fkey, $productgroups_fkey
        );
    }

    if($result->{discount}) {
        $discount->{discount_txt} = $result->{discount};
        if(index($result->{discount}, '%') > -1) {
            my $disc = $result->{discount};
            $disc =~ s/%//g;
            $discount->{discount} = (1-$disc/100) * ($quantity * $price);
        } else {
            my $disc = $result->{discount};
            $discount->{discount} = $quantity * ($price - $disc);
        }
    }

    return $discount;
}
1;