#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use strict;
use warnings;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('venditabant');
$t->post_ok('/api/users/list/' =>
    { 'X-Token-Check' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb21wYW5pZXNfcGtleSI6MjQsImNvbXBhbnkiOiJEYWplIEFCIiwiaXNfYWRtaW4iOjAsInBhc3N3b3JkIjoiMGdZVzZqTXU3dFwvcWVORHVRS2hON2xOSmJtaTRHTkxpVE94ZFZWUnFtazI0TllBamlCVElnRThiNHBTWFdXNmV2R09QRlFXVTBLbXJ0cnZqaFk4ZHVBIiwic3VwcG9ydCI6MSwidXNlcmlkIjoiamFuQGRhamUud29yayIsInVzZXJuYW1lIjoiSmFuIEVza2lsc3NvbiIsInVzZXJzX3BrZXkiOjI0fQ.oUhzZDxjDVNLUhWt81BBtKPFzpFiTBYxTGjW5Pk92V0' }
                                             => json => {
    data => {
        companies_pkey => 30
    }
}
)->status_is(200)->content_like(qr/Success/i);

done_testing();

