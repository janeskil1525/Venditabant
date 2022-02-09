package Invoice::Workflow::Action::Send;
use strict;
use warnings FATAL => 'all';
use base qw( Workflow::Action );
no warnings  'experimental';

use feature 'signatures';

use Data::Dumper;
use Workflow::Factory qw( FACTORY );
use Workflow::History;
use Workflow::Exception qw( workflow_error );

use Mojo::JSON qw{encode_json};

use Invoice::Helpers::Files;
use Engine::Model::Transit;

sub execute ($self, $wf) {

    my $pg =  $self->get_pg();
    my $context = $wf->context;

    $wf->add_history(
        Workflow::History->new({
            action      => "Create mail",
            description => "Mail created",
            user        => $context->param('history')->{userid},
        })
    );

    my $file = Invoice::Helpers::Files->new(
        pg => $pg
    )->load_file(
        $context->param('invoice_fkey'), 'pdf'
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "Get attachment",
            description => "Mail created",
            user        => $context->param('history')->{userid},
        })
    );

    my $payload->{files_fkey} = $file->{files_fkey};
    $payload->{full_path} = $file->{full_path};
    $payload->{invoice_fkey} = $file->{invoice_fkey};
    $payload->{name} = $file->{name};
    $payload->{path} = $file->{path};
    $payload->{type} = $file->{type};

    my $data->{type} = 'workflow';
    $data->{activity} = 'create_mail';
    $data->{workflow} = 'invoice_mail';
    $data->{status} = 0;
    $data->{payload} = encode_json ($payload);

    my $transit_pkey = Engine::Model::Transit->new(
        db => $pg->db
    )->insert(
        $data
    );

    $wf->add_history(
        Workflow::History->new({
            action      => "Insert transit for mailer",
            description => "Mail created transit med pkey '$transit_pkey' skapad",
            user        => $context->param('history')->{userid},
        })
    );

    return $transit_pkey;
}


sub get_pg($self) {
    return  FACTORY->get_persister( 'InvoicePersister' )->get_pg();
}
1;