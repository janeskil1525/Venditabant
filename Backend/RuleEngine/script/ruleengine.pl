###!/usr/bin/perl
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
        Log::Log4perl::init($self->get_configpath() . 'rule_engine_log.conf');
    };
    say $@ if $@;

    $self->_log_script_start();

    my $config;
    eval {
        $config = get_config($self->get_configpath() . 'rule_engine.ini');
    };
    say $@ if $@;

    my $pg = Mojo::Pg->new()->dsn(
        $config->{DATABASE}->{pg}
    );

    #say $pg->db->query('select version() as version')->hash->{version};
    my $log = Log::Log4perl->get_logger();

    try {

    } catch {
        say $_;
        $log->error('execute ' . $_)
    };


    $self->_log_script_done();
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