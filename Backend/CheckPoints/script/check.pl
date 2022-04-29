### # !/opt/ActivePerl-5.26/bin/perl

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
use namespace::clean -except => [qw/_options_data _options_config/];
# use lib '/home/jan/Project/Venditabant/Backend/venditabant/lib/venditabant/Helper/ProcessChecpoints';
use CheckPoints;
use Sentinel::Helpers::Sentinelsender;

option 'configpath' => (
    is 			=> 'ro',
    required 	=> 1,
    reader 		=> 'get_configpath',
    format 		=> 's',
    doc 		=> 'Configuration file',
    default 	=> '/home/jan/Project/Laga-Intern/Admin/conf/'
);

option 'companies_fkey' => (
    is 			=> 'ro',
    reader 		=> 'get_companies_fkey',
    doc 		=> 'companies_fkey for running for only one company',
    default 	=> 0,
    format 		=> 'i',
);

sub check {
    my $self = shift;

    Log::Log4perl->easy_init($ERROR);
    eval {
        Log::Log4perl::init($self->get_configpath() . 'check_log.conf');
    };
    say $@ if $@;

    $self->_log_script_start();

    my $config;
    eval {
        $config = get_config($self->get_configpath() . 'check.ini');
    };
    say $@ if $@;

    my $pg = Mojo::Pg->new()->dsn(
        $config->{DATABASE}->{pg}
    );

    #say $pg->db->query('select version() as version')->hash->{version};
    my $companies_fkey = $self->get_companies_fkey();
    try {
        if ($companies_fkey > 0) {
            CheckPoints->new(
                pg     => $pg,
            )->check(
                $companies_fkey
            )->catch(sub($err) {
                my $log = Log::Log4perl->get_logger();
                $log->error('ProcessChecpoints ' . $err);
            });
        } else {
            CheckPoints->new(
                pg     => $pg,
            )->check_all()->catch(sub($err) {
                my $log = Log::Log4perl->get_logger();
                $log->error('ProcessChecpoints ' . $err);
            });
        }

    }catch{
        say $_;
        Sentinel::Helpers::Sentinelsender->new()->capture_message(
            $pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $_
        );
        my $log = Log::Log4perl->get_logger();
        $log->error('ProcessChecpoints ' . $_)
    };

    $self->_log_script_done();

    return $companies_fkey;
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
    my $infostring = "Process auto_minion starts '$now_string'";
    $log->info($infostring);

    return;
}

sub _log_script_done {
    my $self = shift;

    my $log = Log::Log4perl->get_logger();
    my $now_string = strftime( "%Y-%m-%d %H:%M:%S ", localtime);
    my $infostring = "Process auto_minion ends '$now_string' \n\n\n";
    $log->info($infostring);

    return;
}

main->new_with_options->check();

1;
