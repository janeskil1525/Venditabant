package venditabant::Helpers::Checkpoints::Check;
use Mojo::Base 'venditabant::Helpers::Sentinel::Sentinelsender', -signatures, -async_await;

use venditabant::Model::Checks;
use venditabant::Helpers::Checkpoints::Check::SqlFalse;

use Data::Dumper;

has 'pg';


async sub check ($self, $companies_pkey) {
    my $checks = await venditabant::Model::Checks->new(
        db => $self->pg->db
    )->load_list_p();

    my $companies = await venditabant::Model::Company->new(
        db => $self->pg->db
    )->load_list_p();

    my $db = $self->db;
    my $tx = $db->begin();
    my $err;
    eval {
        foreach my $check (@{$checks}) {
            foreach my $company (@{$companies}) {
                if($check->{check_type} eq 'SQL_FALSE') {
                    await venditabant::Helpers::Checkpoints::Check::SqlFalse->new(
                        db => $db
                    )->check(
                        $company->{companies_pkey}, $check
                    );
                }
            }
        }
    };
    $err = $@ if $@;
    $self->capture_message (
        $self->pg, '',
        'venditabant::Helpers::Checkpoints::Check', 'check', $err
    ) if $err;

}

1;