use strict;
use warnings;
use Test::More;

use venditabant::Helpers::Invoice::From::Salesorder;
use Mojo::Pg;

sub test_purge {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    venditabant::Helpers::Invoice::From::Salesorder->new(
        pg => $pg
    )->convert(24, 24, 4)->catch(sub {
        my $err = shift;

        say $err;
    });

    return 1;
}

ok(test_purge() ne '');


#ok(test_send() ne '' );
done_testing();