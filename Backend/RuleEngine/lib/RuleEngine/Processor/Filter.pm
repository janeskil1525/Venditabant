package RuleEngine::Processor::Filter;
use Moose;

has 'condition' => (
    is => 'ro',
    isa => 'CodeRef',
    required => 1,
    traits => [ 'Code' ],
    handles => {
        check => 'execute_method'
    }
);


__PACKAGE__->meta->make_immutable;
no Moose;

1;