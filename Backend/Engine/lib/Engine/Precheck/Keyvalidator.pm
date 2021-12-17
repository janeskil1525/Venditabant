package Engine::Precheck::Keyvalidator;
use Mojo::Base -base, -signatures, -async_await;


async sub check_key($self, $key, $required, $data) {

    if($required eq 'true' and !exists $data->{$key}) {
        my $log = Log::Log4perl->get_logger();
        $log->debug(
            "Engine::Precheck::Keyvalidator check_key $key is missing"
        );
        $data->{error}->{$key} = "Is missing";
    } elsif ($required eq 'false' and !exists $data->{$key}) {
        $data->{$key} = ''
    }

    return $data;
}
1;