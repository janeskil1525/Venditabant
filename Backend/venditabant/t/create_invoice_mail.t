use strict;
use warnings;
use Test::More;

use venditabant::Helpers::Mailer::Mails::Invoice::Create;
use Mojo::Pg;

sub create {

    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );

    venditabant::Helpers::Mailer::Mails::Invoice::Create->new(
        pg => $pg
    )->create(24, 24, 16)->catch(sub {
        my $err = shift;

        say $err;
    });

    return 1;
}

ok(create() ne '');


#ok(test_send() ne '' );
done_testing();