package venditabant::Helpers::Minion;
use Mojo::Base 'Sentinel::Helpers::Sentinelsender', -signatures, -async_await;


use venditabant::Helpers::Minion::Salesorder;

async sub init($self, $minion) {
    await venditabant::Helpers::Minion::Salesorder->new()->init($minion);
}
1;