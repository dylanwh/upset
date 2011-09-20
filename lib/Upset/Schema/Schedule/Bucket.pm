package Upset::Schema::Schedule::Bucket;
use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;

use MooseX::Params::Validate;
use MooseX::Types::Moose ':all';
use Upset::Schema::Types ':all';

use DateTime::SpanSet;
use DateTime::Event::Recurrence; # so kiokudb can use the deserialized coderefs... eew
use List::MoreUtils 'first_value';

with 'MooseX::Clone';

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'events' => (
    traits   => [ 'Hash', 'Clone' ],
    reader   => '_events',
    isa      => HashRef[Event],
    init_arg => undef,
    default  => sub { +{} },
    handles => {
        _values  => 'values',
        _set     => 'set',
        _delete  => 'delete',
    },
);

sub events {
    my $self = shift;

    return sort { $a->compare($b) } $self->_values;
}

sub add_event {
    my ($self, $event) = @_;

    $self->_set($event->slot => $event);
}

sub remove_event {
    my ($self, $event) = @_;

    $self->_delete($event->slot);
}

sub next_event {
    my $self = shift;
    my ($now) = pos_validated_list( \@_, { isa => 'DateTime' } );

    return first_value { $_->follows($now) } $self->events;
}

__PACKAGE__->meta->make_immutable;
1;
