package venditabant::Controller::Login_1;
use Mojo::Base 'Mojolicious::Plugin::Qooxdoo::JsonRpcController', -signatures;

use venditabant::Helpers::RpcException;

has service => sub { 'Test' };

my %allow = ( echo => 1, bad =>  1, async => 1);

sub allow_rpc_access ($self, $method) {

	return $allow{$method};;
}

sub echo ($self, $text) {

	return $text;
}

sub bad {

	die venditabant::Helpers::RpcException->new(code=>1323,message=>'I died');

	die { code => 1234, message => 'another way to die' };
}
1;
