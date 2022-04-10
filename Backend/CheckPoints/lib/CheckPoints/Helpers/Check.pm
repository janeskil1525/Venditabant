package CheckPoints::Helpers::Check;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use CheckPoints::Model::Checks;
use CheckPoints::Model::AutoTodo;
use CheckPoints::Helpers::Check::SqlFalse;
use CheckPoints::Helpers::Check::SqlList;
use CheckPoints::Helpers::Actions::MissingDeliveryAddress;
use CheckPoints::Helpers::Actions::MissingInvoiceAddress;

use Data::Dumper;

has 'pg';


async sub check ($self, $companies_pkey) {
    my $err;
    my $checks;
    eval {
        $checks = await CheckPoints::Model::Checks->new(
            db => $self->pg->db
        )->load_list_p();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Checkpoints::Check', 'check and load_list_p', $err
    ) if $err;

    my $db = $self->pg->db;
    my $tx = $db->begin();
    eval {
        await CheckPoints::Model::AutoTodo->new(
            db => $db
        )->delete_auto_todos($companies_pkey);
        foreach my $check (@{$checks}) {
            if($check->{check_type} eq 'SQL_FALSE') {
                my $result = await CheckPoints::Helpers::Check::SqlFalse->new(
                    db => $db
                )->check (
                    $companies_pkey, $check
                );
                if(!$result->{result}) {
                    await CheckPoints::Model::AutoTodo->new(
                        db => $db
                    )->upsert_simple(
                        $companies_pkey, $check
                    );
                }
            } elsif ($check->{check_type} eq 'SQL_LIST') {
                my $results = await CheckPoints::Helpers::Check::SqlList->new(
                    db => $db
                )->check(
                    $companies_pkey, $check
                );
                foreach my $result (@{$results}) {
                    my $user_action = '';
                    if($check->{check_name} eq 'CUSTOMER_DELIVERYADDRESS') {
                        $user_action = await CheckPoints::Helpers::Actions::MissingDeliveryAddress->new(
                            pg => $self->pg
                        )->create_text(
                            $companies_pkey, $result, $check
                        );
                    } elsif ($check->{check_name} eq 'CUSTOMER_INVOICEADDRESS') {
                        $user_action = await CheckPoints::Helpers::Actions::MissingInvoiceAddress->new(
                            pg => $self->pg
                        )->create_text(
                            $companies_pkey, $result, $check
                        );
                    }

                    await $self->upsert_user_action(
                        $db,
                        $companies_pkey,
                        $check->{check_type},
                        $check->{check_name},
                        $user_action,
                        $result->{customers_pkey}
                    );

                }
            }
        }
        $tx->commit();
    };
    $err = $@ if $@;

}

async sub upsert_user_action ($self, $db, $companies_pkey, $check_type, $check_name, $user_action, $key_id) {
    await CheckPoints::Model::AutoTodo->new(
        db => $db
    )->upsert_user_action (
        $companies_pkey,
        $check_type,
        $check_name,
        $user_action,
        $key_id
    );
}

1;