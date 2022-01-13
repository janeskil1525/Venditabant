package RuleEngine::Processor::RuleSet;
use Moose;

has 'filter' => (
    is => 'rw',
    isa => 'RuleEngine::Processor::Filter',
    predicate => 'has_filter'
);

has 'description' => (
    is => 'rw',
    isa => 'Str'
);

has 'name' => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has 'rules' => (
    is  => 'rw',
    isa => 'ArrayRef[RuleEngine::Processor::Rule]',
    traits => [ 'Array' ],
    default => sub { [] },
    handles => {
        add_rule => 'push',
        rule_count => 'count'
    }
);

sub execute {
    my ($self, $session, $objects) = @_;

    foreach my $obj (@{ $objects }) {
        foreach my $rule (@{ $self->rules }) {
            $rule->execute($session, $obj) if $rule->evaluate($session, $obj);
        }
    }

    return $objects unless $self->has_filter;
    my @returnable = ();
    foreach my $obj (@{ $objects }) {
        push(@returnable, $obj) if($self->filter->check($session, $obj));
    }

    return \@returnable;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;