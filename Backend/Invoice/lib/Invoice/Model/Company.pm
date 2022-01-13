package Invoice::Model::Company;
use Mojo::Base -base, -signatures;

has 'db';

sub load ($self, $companies_pkey, $users_pkey) {

    my $result = $self->db->select(
        'companies', undef,
        {
            companies_pkey => $companies_pkey
        }
    );
    my $hash;
    $hash = $result->hash if $result and $result->rows > 0;
    return $hash
}
1;