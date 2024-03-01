#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use strict;
use warnings;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('venditabant');

# my $data->{data}->{email} = 'kalle_pelle@olle.com';
# $data->{data}->{user_name} = 'kalle_pelle@olle.com';
# $data->{data}->{company_name} = 'kalle_pelle@olle.com';
# $data->{data}->{company_orgnr} = 'kalle_pelle@olle.com';
# $data->{data}->{company_address} = 'kalle_pelle@olle.com';
# $data->{data}->{password} = 'kalle_pelle@olle.com';
#
# $data->{companies_fkey} = 0;
# $data->{users_fkey} = 0;

# push @{$data->{actions}}, 'signup';

$t->put_ok('/api/signup/' =>
    { 'X-Token-Check' => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb21wYW5pZXNfcGtleSI6MjQsImNvbXBhbnkiOiJEYWplIEFCIiwiaXNfYWRtaW4iOjAsInBhc3N3b3JkIjoiMGdZVzZqTXU3dFwvcWVORHVRS2hON2xOSmJtaTRHTkxpVE94ZFZWUnFtazI0TllBamlCVElnRThiNHBTWFdXNmV2R09QRlFXVTBLbXJ0cnZqaFk4ZHVBIiwic3VwcG9ydCI6MSwidXNlcmlkIjoiamFuQGRhamUud29yayIsInVzZXJuYW1lIjoiSmFuIEVza2lsc3NvbiIsInVzZXJzX3BrZXkiOjI0fQ.oUhzZDxjDVNLUhWt81BBtKPFzpFiTBYxTGjW5Pk92V0' }
                                             => json =>
    {
        'data'           => {
            'userid'           => 'kalle_pelle@olle.com',
            'name'            => 'kalle pelle',
            'password'        => 'password',
            'company_name'    => 'Knep',
            'company_address' => 'Kallevägen',
        },
        'companies_fkey' => 0,
        'users_fkey'     => 0,
    }
)->status_is(200)->content_like(qr/Success/i);

done_testing();

