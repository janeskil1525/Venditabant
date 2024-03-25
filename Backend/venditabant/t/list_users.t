use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('venditabant');
$t->get_ok('/api/v1/v_users_companies_fkey/list/' => {
    'X-Token-Check' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb21wYW5pZXNfcGtleSI6MjQsImNvbXBhbnkiOiJEYWplIEFCIiwiaXNfYWRtaW4iOjAsInBhc3N3b3JkIjoiMGdZVzZqTXU3dFwvcWVORHVRS2hON2xOSmJtaTRHTkxpVE94ZFZWUnFtazI0TllBamlCVElnRThiNHBTWFdXNmV2R09QRlFXVTBLbXJ0cnZqaFk4ZHVBIiwic3VwcG9ydCI6MSwidXNlcmlkIjoiamFuQGRhamUud29yayIsInVzZXJuYW1lIjoiSmFuIEVza2lsc3NvbiIsInVzZXJzX3BrZXkiOjI0fQ.oUhzZDxjDVNLUhWt81BBtKPFzpFiTBYxTGjW5Pk92V0'
})->status_is(200)->content_like(qr/Mojolicious/i);

done_testing();
