package Sentinel::Helpers::Sentinelsender;
use Mojo::Base -base, -strict, -signatures, -async_await;

use Sentinel::Model::Sentinel;
use Sentinel::Model::Log;;

use Scalar::Util qw{blessed};
use Data::Dumper;
use Try::Tiny;

# Sentinel sender
#
# Synopsis
# ========
# use venditabant::Helpers::Sentinel::Sentinelsender;
#
#
# Howto
# =====
# my $sender = venditabant::Helpers::Sentinel::Sentinelsender->new(
#   endpoint      => 'https://sentinel.example.com',
#   authorization => 'Athorisation key'
# );
#
# $sender->capture_message($organisation, $source, $object, $method, $message, $recipients, $errtype);
#
# $sender->log_message($organisation, $source, $object, $method, $message, $recipients, $logtype);
#
# Errtypes
# 0 = Generic error
# 1 = Matotorit image error
# 2 = Remove image in orion error
# 3 = Upload image to orion error
# 4 = Save stockitem in orion error
# 5 = Delete from delart archive in orion error
# 6 = Matorit FTP Error
# 7 = Matotorit image full cd ..error
#
# Logtypes
# 0 = Generic log
# 1 = Orion communication
#
# ======================

sub capture_message ($self, $pg, $organisation = 'venditabant', $source = '', $method = '', $message ='', $recipients = '') {

    $organisation = 'venditabant' unless $organisation;
    $recipients = 'janeskil1525@gmail.com';
    $method = (split(/::/,$method))[-1];

    my $mess;
    if(blessed($message) eq 'Mojo::Exception') {
        $mess  = $message->message();
    } else {
        $mess = $message;
    }

    my $data = $self->get_format(
        $organisation, $source, $method, $mess, $recipients
    );
    Sentinel::Model::Sentinel->new(db => $pg->db)->insert($data);
}

sub get_format ($self, $organisation, $source, $method, $message, $recipients) {

    $organisation 	= '' unless $organisation;

    $source 		= '' unless $source;
    $method 		= '' unless $method;
    $message 		= '' unless $message;
    $recipients 	= '' unless $recipients;


    my $data->{organisation} = $organisation;
    $data->{source} = $source;
    $data->{method} = $method;
    $data->{message} = $message;
    $data->{recipients} = $recipients;

    return $data;
}

sub capture_log($self, $pg, $source, $method, $message) {

    my $data = $self->get_log_format($source, $method, $message);
    Sentinel::Model::Log->new(db => $pg->db)->insert($data);
}

sub get_log_format ($self, $source, $method, $message ) {

    $source 		= '' unless $source;
    $method 		= '' unless $method;
    $message 		= '' unless $message;

    my $data->{source} = $source;
    $data->{method} = $method;
    $data->{message} = $message;

    return $data;
}
1;