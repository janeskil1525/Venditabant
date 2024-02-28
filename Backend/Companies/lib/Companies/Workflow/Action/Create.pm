package Companies::Workflow::Action::Create;
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
use Engine::Model::Workflowrelation;

sub execute ($self, $wf) {

    my $pg = $self->get_pg('CompaniesPersister');
    my $context = $wf->context;

    my $db = $pg->db;
    my $tx = $db->begin;
    my $data = $context->param('data');

    my $company = $data->{'data'}->{company_name};
    my $err ='';

    $wf->add_history(
        Workflow::History->new({
            action      => "New company",
            description => "Company $company will be created",
            user        => $data->{data}->{email},
        })
    );


    my $company_stmt = qq {
        INSERT INTO companies (name, address1, languages_fkey)
        VALUES (?, ?,(SELECT languages_pkey FROM languages WHERE lan = 'swe'))
        RETURNING companies_pkey;
    };

    # company_address:company_address,
    eval {

        my $companies_pkey = $db->query(
            $company_stmt,
            ($data->{data}->{company_name}, $data->{data}->{company_address})
        )->hash->{companies_pkey};

        Release::Helpers::Release->new(
            db => $db
        )->release_single_company(
            $companies_pkey
        );

        my $workflow = $context->param('workflow');
        Engine::Model::Workflowrelation->new(
            db => $db
        )->insert(
            $wf->id,
            $companies_pkey,
            0,
            $workflow
        );

        $wf->context->param('companies_fkey' => $companies_pkey);
        $tx->commit;
    };
    $err = $@ if $@;
    Sentinel::Helpers::Sentinelsender->new()->capture_message (
        $pg, (caller(0))[1], (caller(0))[0], (caller(0))[3], $err
    ) if $err;

    workflow_error $err if $err;

    $wf->add_history(
        Workflow::History->new({
            action      => "New company created",
            description => "Company $company was created",
            user        => $data->{data}->{email},
        })
    );

    if($err) {
        return $err;
    } else {
        return 'success';
    }
}


1;