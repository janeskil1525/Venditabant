package venditabant::Helpers::Mailer::Mails::Invoice::Create;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Helpers::Invoice::Invoices;
use venditabant::Helpers::Mailer::Mails::Loader::Templates;
use Data::UUID;

use Data::Dumper;

has 'pg';

async sub create($self, $companies_pkey, $users_pkey, $invoice_pkey) {

    my $invoice = await venditabant::Helpers::Invoice::Invoices->new(
        pg => $self->pg
    )->load_invoice_full(
        $companies_pkey, $users_pkey, $invoice_pkey
    );

    my $ug = Data::UUID->new();
    my $token = $ug->create();
    $invoice->{id_token} = $ug->to_string($token);

    my $template = await venditabant::Helpers::Mailer::Mails::Loader::Templates->new(
        pg => $self->pg
    )->load_template(
        $companies_pkey, $users_pkey,'Invoice'
    );

    my $mail_content = await venditabant::Helpers::Mailer::Mails::Mapper::Map->new(
        pg => $self->pg
    )->map_data(
        $companies_pkey, $users_pkey, 'Invoice', $invoice, $template
    );

    my $recipients = await $self->get_recipients($companies_pkey, $invoice);
    my $subject = await $self->get_subject(companies_pkey, $invoice);

    await venditabant::Helpers::Mailer::System::Sender->new(
        pg => $self->pg
    )->send()

}
1;