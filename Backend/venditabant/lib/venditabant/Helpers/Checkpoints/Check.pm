package venditabant::Helpers::Checkpoints::Check;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Checks;
use venditabant::Helpers::Checkpoints::Check::SqlFalse;

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
                    )->upsert(
                        $companies_pkey, $check
                    );
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

1;