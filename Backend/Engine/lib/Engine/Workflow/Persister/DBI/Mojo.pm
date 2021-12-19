package Engine::Workflow::Persister::DBI::Mojo;
use strict;
use warnings FATAL => 'all';
use base qw (Workflow::Persister::DBI::ExtraData);
no warnings  'experimental';

use feature 'signatures';

use Mojo::Pg;

use Workflow::Exception qw( configuration_error persist_error );
use Syntax::Keyword::Try;

sub init {
    my ( $self, $params ) = @_;

    # delegate the other assignment tasks to the parent class
    $self->SUPER::init( $params );
}

sub create_handle ($self) {
    unless ( $self->dsn ) {
        configuration_error "DBI persister configuration must include ",
            "key 'dsn' which maps to the first paramter ",
            "in the DBI 'connect()' call.";
    }
    my $dbh;
    try {
        my $pg = Mojo::Pg->new->dsn( $self->dsn
            #"dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
        );
        $self->set_pg($pg);
        $dbh = $self->get_pg->db->dbh;
    }
    catch ($error) {
        persist_error $error;
    };
    $dbh->{RaiseError} = 1;
    $dbh->{PrintError} = 0;
    $dbh->{ChopBlanks} = 1;
    $dbh->{AutoCommit} = $self->autocommit();
    $self->log->debug( "Connected to database '",
        $self->dsn, "' and ", "assigned to persister ok" );

    return $dbh;
}

sub set_pg($self, $pg) {
    $self->{pg} = $pg;
}

sub get_pg($self) {
    my $pg = Mojo::Pg->new->dsn( $self->dsn
        #"dbi:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres;password=PV58nova64"
    );
    return $pg;
}
1;