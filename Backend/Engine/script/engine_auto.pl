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
no warnings 'experimental';

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
        Log::Log4perl::init($self->get_configpath() . 'engine_auto_log.conf');
    };
    say $@ if $@;

    $self->_log_script_start();

    my $config;
    eval {
        $config = get_config($self->get_configpath() . 'engine_auto.ini');
    };
    say $@ if $@;

    my $pg = Mojo::Pg->new()->dsn(
        $config->{DATABASE}->{pg}
    );

    #say $pg->db->query('select version() as version')->hash->{version};
    my $log = Log::Log4perl->get_logger();

    $self->_process_auto_conditions($log, $pg, $config);

    $self->_log_script_done();
}

sub _process_auto_conditions($self, $log, $pg, $config) {

    try {
        Engine->new(
            pg => $pg,
            config => $config
        )->auto_transits()->then(sub{
            my $result = shift;
            $result = $result;
        })->catch(sub{
            my $err = shift;
            $log->error('execute ' . $err);

        })->wait();
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