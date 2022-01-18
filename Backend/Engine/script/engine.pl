####!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

use Moo;
use MooX::Options;
use Data::Dumper;
use feature 'say';
use feature 'signatures';
use POSIX qw(strftime);
use Config::Tiny;
use Try::Tiny;
use Cwd;
use Log::Log4perl qw(:easy);
use Mojo::Pg;
use Mojo::JSON qw {decode_json};
use namespace::clean -except => [qw/_options_data _options_config/];
use Engine;

use Engine::Model::Transit;

option 'configpath' => (
    is 			=> 'ro',
    required 	=> 1,
    reader 		=> 'get_configpath',
    format 		=> 's',
    doc 		=> 'Configuration file',
    default 	=> '/home/jan/Project/Laga-Intern/Admin/conf/'
);


sub execute {
    my $self = shift;

    Log::Log4perl->easy_init($ERROR);
    eval {
        Log::Log4perl::init($self->get_configpath() . 'engine_log.conf');
    };
    say $@ if $@;

    $self->_log_script_start();

    my $config;
    eval {
        $config = get_config($self->get_configpath() . 'engine.ini');
    };
    say $@ if $@;

    my $pg = Mojo::Pg->new()->dsn(
        $config->{DATABASE}->{pg}
    );

    #say $pg->db->query('select version() as version')->hash->{version};
    my $log = Log::Log4perl->get_logger();

    # $self->_process_conditions($log, $pg);
    $self->_process_transit($log, $pg);


    $self->_log_script_done();
}

sub _process_auto_conditions($self, $log, $pg) {

    try {

    } catch {
        say $_;
        $log->error('execute ' . $_)
    };
}

sub _process_transit($self, $log, $pg) {

    try {
        my $transits = Engine::Model::Transit->new(db => $pg->db)->load_transits('workflow', 0);
        foreach my $transit (@{$transits}) {
            Engine::Model::Transit->new(
                db => $pg->db
            )->set_status(
                $transit->{transit_pkey}, 1
            );

            $log->debug('execute ' . $transit->{workflow} . ' ' . $transit->{activity});

            my $data = decode_json $transit->{payload};
            if(index($transit->{activity},',') > -1) {
                @{$data->{actions}} = split(', ', $transit->{activity});
            } else {
                push @{$data->{actions}}, $transit->{activity};
            }

            Engine->new(
                pg => $pg,
                config => $config
            )->execute(
                $transit->{workflow}, $data
            )->then(sub{
                my $result = shift;
                Engine::Model::Transit->new(
                    db => $pg->db
                )->set_status($transit->{transit_pkey}, 2);
            })->catch(sub{
                my $err = shift;
                $log->error('execute ' . $err);
                Engine::Model::Transit->new(
                    db => $pg->db
                )->set_status($transit->{transit_pkey}, 0);
            })->wait();
        }

    } catch {
        say $_;
        $log->error('execute ' . $_)
    };
}

sub get_config{
    my ($configfile) = @_;

    my $log = Log::Log4perl->get_logger();
    $log->logdie("config file name is empty")
        unless ($configfile);

    my $config = Config::Tiny->read($configfile);
    $log->logdie("config file could not be read")
        unless ($config);

    return $config;
}

sub _log_script_start {
    my $self = shift;

    my $log = Log::Log4perl->get_logger();
    my $now_string = strftime( "%Y-%m-%d %H:%M:%S ", localtime);
    my $infostring = "Process execute starts '$now_string'";
    $log->info($infostring);

    return;
}

sub _log_script_done {
    my $self = shift;

    my $log = Log::Log4perl->get_logger();
    my $now_string = strftime( "%Y-%m-%d %H:%M:%S ", localtime);
    my $infostring = "Process execute ends '$now_string' \n\n\n";
    $log->info($infostring);

    return;
}

main->new_with_options->execute();
1;