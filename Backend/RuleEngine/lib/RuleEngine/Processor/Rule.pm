package RuleEngine::Processor::Rule;
use Moose;

has 'action' => (
    is => 'rw',
    isa => 'CodeRef',
    traits => [ 'Code' ],
    required => 1,
    handles => {
        execute => 'execute_method'
    }
);

has 'condition' => (
    is => 'rw',
    isa => 'CodeRef',
    traits => [ 'Code' ],
    required => 1,
    handles => {
        evaluate => 'execute_method'
    }
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

__PACKAGE__->meta->make_immutable;
no Moose;
1;