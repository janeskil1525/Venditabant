package venditabant::Helpers::Checkpoints::Check;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Checks;
use venditabant::Helpers::Checkpoints::Check::SqlFalse;
use venditabant::Helpers::Checkpoints::Actions::MissingDeliveryAddress;

use Data::Dumper;

has 'pg';


async sub check ($self, $companies_pkey) {
    my $err;
    my $checks;
    eval {
        $checks = await venditabant::Model::Checks->new(
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
        foreach my $check (@{$checks}) {
            if($check->{check_type} eq 'SQL_FALSE') {
                my $result = await venditabant::Helpers::Checkpoints::Check::SqlFalse->new(
                    db => $db
                )->check (
                    $companies_pkey, $check
                );
                if(!$result->{result}) {
                    venditabant::Model::AutoTodo->new(
                        db => $db
                    )->upsert_simple(
                        $companies_pkey, $check
                    );
                }
            } elsif ($check->{check_type} eq 'SQL_LIST') {
                my $results = venditabant::Helpers::Checkpoints::Check::SqlList->new(
                    db => $db
                )->check(
                    $companies_pkey, $check
                );
                foreach my $result (@{$results}) {
                    if($check->{check_name} eq 'CUSTOMER_DELIVERYADDRESS') {
                        my $user_action = await venditabant::Helpers::Checkpoints::Actions::MissingDeliveryAddress->new(
                            pg => $self->pg
                        )->create_text(
                            $companies_pkey, $result
                        );
                        await $self->upsert_user_action(
                            $db,
                            $companies_pkey,
                            $check->{check_type},
                            $check->{check_name},
                            $user_action,
                            $result->{customers_fkey}
                        );
                    }
                }
            }
        }
        $tx->commit();
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Checkpoints::Check', 'check and check', $err
    ) if $err;
}

async sub upsert_user_action ($self, $db, $companies_pkey, $check_type, $check_name, $user_action, $key_id) {
    await venditabant::Model::AutoTodo->new(
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