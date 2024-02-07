package Companies::Workflow::Action::SignUp;
use strict;
use warnings FATAL => 'all';
use base qw( Engine::Workflow::Action::Base );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );
use Digest::SHA qw{sha512_base64};

use Sentinel::Helpers::Sentinelsender;
use Release::Helpers::Release;
use Companies::Model::Workflow;

sub execute ($self, $wf) {

    my $pg = $self->get_pg('CompaniesPersister');
    my $context = $wf->context;

    my $db = $pg->db;
    my $tx = $db->begin;
    my $data = $context->param('company');

    my $company = $context->param('company')->{company_name};

    $wf->add_history(
        Workflow::History->new({
            action      => "New company",
            description => "Company $company will be created",
            user        => $data->{email},
        })
    );

    my $company_stmt = qq {
        INSERT INTO companies (name, registrationnumber, languages_fkey)
        VALUES (?, ?,(SELECT languages_pkey FROM languages WHERE lan = 'swe'))
        RETURNING companies_pkey;
    };

    my $users_stmt = qq {
        INSERT INTO users (userid, username, passwd, active, languages_fkey)
        VALUES (?,?,?,?, (SELECT languages_pkey FROM languages WHERE lan = 'swe'))
        RETURNING users_pkey;
    };

    my $users_companies_stmt = qq {
        INSERT INTO users_companies (companies_fkey, users_fkey) VALUES (?,?);
    };

    $data->{password} = sha512_base64($data->{password});
    my $err = '';
    # company_address:company_address,
    eval {

        my $companies_pkey = $db->query(
            $company_stmt,
                ($data->{company_name}, $data->{company_orgnr})
        )->hash->{companies_pkey};

        my $users_pkey = $db->query(
            $users_stmt,
                ($data->{email}, $data->{user_name},$data->{password},1)
        )->hash->{users_pkey};

        $db->query(
            $users_companies_stmt,
                ($companies_pkey, $users_pkey)
        );

        Release::Helpers::Release->new(
            db => $db
        )->release_single_company(
            $companies_pkey
        );

        Companies::Model::Workflow->new(
            db => $db
        )->insert(
            $wf->id, $users_pkey, $companies_pkey
        );
        $tx->commit;
    };
    $err = $@ if $@;
    Sentinel::Helpers::Sentinelsender->new()->capture_message (
        $pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;

    $wf->add_history(
        Workflow::History->new({
            action      => "New company created",
            description => "Company $company was created",
            user        => $data->{email},
        })
    );

    if($err) {
        return $err;
    } else {
        return 'success';
    }

}


1;