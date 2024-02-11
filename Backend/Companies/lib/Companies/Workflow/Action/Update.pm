package Companies::Workflow::Action::Update;
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
use Companies::Helpers::Company;

sub execute ($self, $wf) {

    my $pg = $self->get_pg('CompaniesPersister');
    my $context = $wf->context;

    my $db = $pg->db;
    my $tx = $db->begin;
    my $data = $context->param('company');


    my $result = Companies::Helpers::Company->new(
        pg => $pg
    )->save_company(
        $context->param('companies_fkey'), $context->param('users_fkey'), $data
    );

    print "Before exceptttion" . Dumper($result) . "\n";
    workflow_error($result) unless $result eq 'success';

    my $name = $context->param('company')->{name};
    $wf->add_history(
        Workflow::History->new({
            action      => "Company updated",
            description => "Company $name was updated",
            user        => $context->param('history')->{userid},
        })
    );

    return $result;
}
1;