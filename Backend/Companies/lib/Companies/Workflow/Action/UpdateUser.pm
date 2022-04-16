package Companies::Workflow::Action::UpdateUser;
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

    my $data = $context->param('user');

    my $user = $data->{userid};

    my $companies_fkey = $context->param('companies_fkey');
    my $result = Companies->new(
        pg => $pg
    )->upsert_user(
        $companies_fkey, $data
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "User was updated",
            description => "User $user was updated",
            user        => $context->param('history')->{userid},
        })
    );

    return $result;

}
1;