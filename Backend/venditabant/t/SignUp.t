#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('venditabant');
$t->get_ok('/api/signup/' => json => {
        'email' => 'janeskil1525@gmail.com',
        'company_orgnr' => 'dfgdsgfs',
        'password' => '1234',
        'user_name' => 'Jan Eskilsson',
        'company_name' => 'gdsfgsdf',
        'company_address' => 'Winkergasse 24b'

})->status_is(200)->content_like(qr/Success/i);

done_testing();

