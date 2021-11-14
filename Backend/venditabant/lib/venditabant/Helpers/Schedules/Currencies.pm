package venditabant::Helpers::Schedules::Currencies;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use XML::Hash::XS;
use DateTime;

use venditabant::Model::Currency::Currencies;
use venditabant::Model::Currency::Exchangerates;

#use SOAP::Data;

use Mojo::UserAgent;

use Data::Dumper;

has 'address' => 'https://swea.riksbank.se:443/sweaWS/services/SweaWebServiceHttpSoap12Endpoint';
has 'db';

async sub work($self) {

    my $next_run = DateTime->now();

    my $result = await $self->load_currencies();
    if($result eq 'success') {
        $result = await $self->load_exchangerates();
    }
    if($result eq 'success') {
        $next_run = DateTime->now()->add(days => 1)->set_hour(10)->set_minute(1)->set_second(1);
    }
    my $return_val->{nextrun} = "$next_run";
    $return_val->{result} = $result;

    return $return_val;
}

async sub load_exchangerates($self) {
    my $result;
    my $data = await $self->_exchangerate_request();

    my $ua  = Mojo::UserAgent->new();

    my $res = $ua->post($self->address(),
        {'Content-Type' => 'application/soap+xml;charset=UTF-8;action="urn:getLatestInterestAndExchangeRates"'},
        $data
    )->result;

    if($res->is_success) {
        my $xmlstr =  $res->body;
        my $hashes   = XML::Hash::XS
            ->new(utf8 => 0, encoding => 'utf-8')
            ->xml2hash($xmlstr, encoding => 'cp1251')
            ->{'SOAP-ENV:Body'}
            ->{'ns0:getLatestInterestAndExchangeRatesResponse'}
            ->{return}
            ->{groups}
            ->{series};
        await $self->_save_exchangerates($hashes);
        $result = 'success';
    } elsif ($res->is_error) {
        $result = $res->message;
    }
    return $result;
}

async sub _save_exchangerates($self, $exchangerates) {

    my $cur = venditabant::Model::Currency::Exchangerates->new(db => $self->db);
    foreach my $rate (@{$exchangerates}) {
        my $exchangerate->{ratedate} = $rate->{resultrows}->{date}->{content};
        $exchangerate->{value} = $rate->{resultrows}->{value}->{content};
        $exchangerate->{seriesid} = $rate->{seriesid}->{content};
        $exchangerate->{seriesname} = $rate->{seriesname}->{content};
        $exchangerate->{unit} = $rate->{unit}->{content};
        $exchangerate->{value} = $rate->{resultrows}->{value}->{content};

        await $cur->upsert($exchangerate);
    }
}

async sub _exchangerate_request($self) {
    my $currencies = await venditabant::Model::Currency::Currencies->new(
        db => $self->db
    )->load_currency_list();

    my $seriesid;
    foreach my $currency (@{$currencies}) {
        $seriesid .= "<seriesid>" . $currency->{seriesid} . "</seriesid>" . "\n";
    }

   return  qq{
        <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsd="http://swea.riksbank.se/xsd">
           <soap:Header/>
           <soap:Body>
              <xsd:getLatestInterestAndExchangeRates>
                 <languageid>sv</languageid>
                 <!--1 or more repetitions:-->
    } . $seriesid . qq {
             </xsd:getLatestInterestAndExchangeRates>
           </soap:Body>
        </soap:Envelope>
    };
}

async sub load_currencies($self) {
    my $result;
    my $data = await $self->_currency_request();

    my $ua  = Mojo::UserAgent->new();

    my $res = $ua->post($self->address(),
        {'Content-Type' => 'application/soap+xml;charset=UTF-8;action="urn:getInterestAndExchangeNames"'},
        $data
    )->result;

    if($res->is_success) {
        my $xmlstr =  $res->body;
        my $hashes   = XML::Hash::XS
            ->new(utf8 => 0, encoding => 'utf-8')
            ->xml2hash($xmlstr, encoding => 'cp1251')
            ->{'SOAP-ENV:Body'}
            ->{'ns0:getInterestAndExchangeNamesResponse'}
            ->{return};
        await $self->_save_currencies($hashes);
        $result = 'success';
    } elsif ($res->is_error) {
        $result = $res->message;
    }
    return $result;
}

async sub _save_currencies($self, $hashes) {

    my $currency = venditabant::Model::Currency::Currencies->new(
        db => $self->db
    );

    foreach my $hash (@{$hashes}) {
        if(!exists $hash->{dateto}->{content}) {
            my $cur->{shortdescription} = $hash->{shortdescription}->{content};
            $cur->{longdescription} = $hash->{longdescription}->{content};
            $cur->{description} = $hash->{description}->{content};
            $cur->{seriesid} = $hash->{seriesid}->{content};

            await $currency->upsert($cur);
        }
    }
    my $cur->{shortdescription} = 'SEK';
    $cur->{longdescription} = 'Svenska kronor';
    $cur->{description} = 'Svenska kronor';
    $cur->{seriesid} = 'SEK';

    await $currency->upsert($cur);
}

async sub _currency_request($self) {
    return qq{
       <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsd="http://swea.riksbank.se/xsd">
       <soap:Header/>
           <soap:Body>
              <xsd:getInterestAndExchangeNames>
                 <groupid>130</groupid>
                 <languageid>sv</languageid>
              </xsd:getInterestAndExchangeNames>
           </soap:Body>
        </soap:Envelope>
    };
}

1;