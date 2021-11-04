package venditabant::Helpers::Mailer::Mails::Invoice::Text;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use HTML::Entities;
use Text::Template;

async sub map_text($self, $companies_pkey, $users_pkey, $invoice, $template) {

    my $header = await $self->_create_header($invoice, $template->{header_value}, $template->{sub3} );
    my $body = await $self->_create_body($invoice, $template->{body_value}, $template->{sub1});
    my $footer = await $self->_create_footer($invoice, $template->{footer_value});

    return $header . $body . $footer;
}

async sub _create_footer($self, $invoice, $template) {

    # my $footer_templ = Text::Template->new(TYPE => 'STRING', SOURCE => $template->{footer} );

    return $template;
}

async sub _create_body ($self, $invoice, $template, $summary) {

    my $body = '';

    foreach my $item (@{$invoice->{items}}) {
        my $body_templ = Text::Template->new(TYPE => 'STRING', SOURCE => $template );
        my $hash_body = await $self->_get_body_hash($item);
        $body .= $body_templ->fill_in(HASH => $hash_body);
    }
    my $summary = await $self->get_summary($invoice, $summary);
    $body .= $summary;

    return $body;
}

async sub get_summary($self, $invoice, $template) {

    my $hash = {
        netsum => $invoice->{invoice}->{netsum},
        vatsum => $invoice->{invoice}->{vatsum},
        total => $invoice->{invoice}->{total},
    };

    my $body_summary = Text::Template->new(TYPE => 'STRING', SOURCE => $template );
    my $body_summary_sum = $body_summary->fill_in(HASH => $hash);

    return $body_summary_sum;
}

async sub _get_body_hash($self, $item) {

    my $hash = {
            stockitem => encode_entities($item->{stockitem}),
            description => encode_entities($item->{description}),
            price => $item->{price},
            quantity => $item->{quantity},
            total => $item->{total}
    };

    #return $hash;
}

async sub _create_header($self, $invoice, $template, $style) {

    my $header_templ = Text::Template->new(TYPE => 'STRING', SOURCE => $template );
    my $hash_header = await $self->_get_header_hash($invoice, $style);

    my $header = $header_templ->fill_in(HASH => $hash_header);
    return $header;
}

async sub _get_header_hash($self, $invoice, $style) {

    my $hash_header = {
        invoiceno       => $invoice->{invoice}->{invoiceno},
        company         => encode_entities($invoice->{company}->{name}),
        companyaddress1 => encode_entities($invoice->{company}->{address1}),
        companyaddress2 => encode_entities($invoice->{company}->{address2}),
        companyzipcode  => $invoice->{company}->{zipcode},
        companycity     => encode_entities($invoice->{company}->{city}),
        companyphone    => $invoice->{company}->{phone},
        customer        => encode_entities($invoice->{customer}->{customer}),
        name            => encode_entities($invoice->{customer}->{name}),
        address1        => encode_entities($invoice->{invoice}->{address1}),
        zipcode         => $invoice->{invoice}->{zipcode},
        city            => encode_entities($invoice->{invoice}->{city}),
        mail            => $invoice->{customer}->{mail},
        invoicedate     => substr($invoice->{invoice}->{invoicedate},0,10),
        paydate         => substr($invoice->{invoice}->{paydate},0,10),
        styling         => $style,
    };

    return $hash_header;
}

async sub _get_style($self) {
    return qq{.clearfix:after {
  content: "";
  display: table;
  clear: both;
}

a {
  color: #5D6975;
  text-decoration: underline;
}

body {
  position: relative;
  width: 21cm;
  height: 29.7cm;
  margin: 0 auto;
  color: #001028;
  background: #FFFFFF;
  font-family: Arial, sans-serif;
  font-size: 12px;
  font-family: Arial;
}

header {
  padding: 10px 0;
  margin-bottom: 30px;
}

#logo {
  text-align: center;
  margin-bottom: 10px;
}

#logo img {
  width: 90px;
}

h1 {
  border-top: 1px solid  #5D6975;
  border-bottom: 1px solid  #5D6975;
  color: #5D6975;
  font-size: 2.4em;
  line-height: 1.4em;
  font-weight: normal;
  text-align: center;
  margin: 0 0 20px 0;
  background: url(dimension.png);
}

#project {
  float: left;
}

#project span {
  color: #5D6975;
  text-align: right;
  width: 52px;
  margin-right: 10px;
  display: inline-block;
  font-size: 0.8em;
}

#company {
  float: right;
  text-align: right;
}

#project div,
#company div {
  white-space: nowrap;
}

table {
  width: 100%;
  border-collapse: collapse;
  border-spacing: 0;
  margin-bottom: 20px;
}

table tr:nth-child(2n-1) td {
  background: #F5F5F5;
}

table th,
table td {
  text-align: center;
}

table th {
  padding: 5px 20px;
  color: #5D6975;
  border-bottom: 1px solid #C1CED9;
  white-space: nowrap;
  font-weight: normal;
}

table .service,
table .desc {
  text-align: left;
}

table td {
  padding: 20px;
  text-align: right;
}

table td.service,
table td.desc {
  vertical-align: top;
}

table td.unit,
table td.qty,
table td.total {
  font-size: 1.2em;
}

table td.grand {
  border-top: 1px solid #5D6975;;
}

#notices .notice {
  color: #5D6975;
  font-size: 1.2em;
}

footer {
  color: #5D6975;
  width: 100%;
  height: 30px;
  position: absolute;
  bottom: 0;
  border-top: 1px solid #C1CED9;
  padding: 8px 0;
  text-align: center;
}}
}
1;