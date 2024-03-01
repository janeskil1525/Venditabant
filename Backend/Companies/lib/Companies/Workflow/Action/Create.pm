package Companies::Workflow::Action::Create;
use Mojo::Base 'Engine::Workflow::Action::Base', -base, -signatures;

use Data::Dumper;

use Workflow::Exception qw( workflow_error );
use Release::Helpers::Release;

sub execute ($self, $wf) {

    $self->_init($wf, 'CompaniesPersister');

    my $company = $self->data->{'data'}->{company_name};
    my $err ='';

    eval {
        $self->add_history($wf, "New company", "Company $company will be created", $self->data->{data}->{email});
        my $company_stmt = $self->_companies_stmt();
        my $companies_pkey = $self->db->query(
            $company_stmt,
            ($self->data->{data}->{company_name}, $self->data->{data}->{company_address})
        )->hash->{companies_pkey};

        Release::Helpers::Release->new(
            db => $self->db
        )->release_single_company(
            $companies_pkey
        );

        $self->set_workflow_relation($companies_pkey, 0, $self->workflow, $wf->id, $companies_pkey);

        $wf->context->param('companies_fkey' => $companies_pkey);

        $self->tx->commit;
    };
    $err = $@ if $@;
    $self->capture_message($@, (caller(0))[1], (caller(0))[0], (caller(0))[3]) if $@;;

    $self->add_history($wf, "New company created", "Company $company was created", $self->data->{data}->{email});

    if($err) {
        return $err;
    } else {
        return 'success';
    }
}

sub _companies_stmt($self) {

    return qq {
        INSERT INTO companies (name, address1, languages_fkey)
        VALUES (?, ?,(SELECT languages_pkey FROM languages WHERE lan = 'swe'))
        RETURNING companies_pkey;
    };
}
1;