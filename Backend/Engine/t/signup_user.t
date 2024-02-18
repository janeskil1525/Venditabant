#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Mojo::Pg;
use Engine;

sub execute {
    my $pg = Mojo::Pg->new->dsn(
        "dbi:Pg:dbname=Venditabant;host=192.168.1.117;port=15432;user=postgres;password=PV58nova64"
    );

    my  $data->{user}->{userid} = 'wwwwwww@kalle.com';
    $data->{user}->{active} = 1;
    $data->{user}->{password} = 'wwwwwWWEEERRRww';
    $data->{user}->{username} = 'kalle olle """"""" !!!!!!!!!!!!';
    $data->{user}->{companies_fkey} = 12;
    push @{$data->{actions}}, 'create_user';

    my $config->{engine}->{conf_path} = '/home/jan/IdeaProjects/Venditabant/Backend/venditabant/conf/engine_log.conf';
    #$config->{engine}->{workflows_path} = '/home/jan/Project/Venditabant/Backend/Engine/conf/workflows/';

    my $engine = Engine->new(
        pg => $pg,
        config => $config
    );

    $engine->execute(
        'Users', $data
    )->catch(sub{
        my $err = shift;
        print $err . '\n';
    })->wait();

    my $context = $engine->context();

    return 1;
}

ok(execute() ne '');
done_testing();

