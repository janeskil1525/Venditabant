package RuleEngine::Processor::Session;
use Moose;

has 'environment' => (
    is => 'rw',
    isa => 'HashRef',
    traits => [ 'Hash' ],
    handles => {
        set_environment => 'set',
        get_environment => 'get'
    },
    default => sub { {} }
);

has 'rulesets' => (
    is  => 'rw',
    isa => 'HashRef[RuleEngine::Processor::RuleSet]',
    traits => [ 'Hash' ],
    default => sub { {} },
    handles => {
        add_ruleset => 'set',
        get_ruleset => 'get',
        ruleset_count => 'count'
    }
);

sub execute {
    my ($self, $name, $objects) = @_;

    die 'Must supply some objects' unless defined($objects);

    my $rs = $self->get_ruleset($name);
    unless(defined($rs)) {
        die "Uknown RuleSet: $name";
    }

    if(ref($objects) ne 'ARRAY') {
        my @objs = ( $objects );
        $objects = \@objs;
    }

    return $rs->execute($self, $objects);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;