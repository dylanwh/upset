package Upset::Schema::Schedule::Bucket;
use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;

use MooseX::Params::Validate;
use MooseX::Types::Moose ':all';
use Upset::Schema::Types ':all';

use DateTime::SpanSet;
use DateTime::Event::Recurrence; # so kiokudb can use the deserialized coderefs... eew

with 'MooseX::Clone';

has '_spanset' => (
    traits    => ['Clone'],
    isa       => 'DateTime::SpanSet',
    is        => 'ro',
    init_arg  => 'spanset',
    predicate => '_has_spanset',
);

has '_events' => (
    traits   => [ 'Array', 'Clone' ],
    is       => 'ro',
    isa      => ArrayRef[Event],
    init_arg => 'events',
    default  => sub { [] },
    handles  => {
        events        => 'elements',
        add_event     => 'push',
        _event        => 'accessor',
        _find_event   => 'first',
        _count_events => 'count',
        _sort_events  => [ 'sort_in_place', sub { $_[0]->compare( $_[1] ) } ],
    },
);

sub BUILD { shift->_sort_events }

after 'add_event' => sub {
    my $self = shift;
    $self->_sort_events;
};

sub next_event {
    my $self = shift;
    my ($now) = pos_validated_list( \@_, { isa => 'DateTime' } );

    if (my $event = $self->_find_event( sub { $_->follows($now) } )) {
        return $event;
    }
    elsif ($self->_has_spanset && $self->_count_events) {
        my $span  = $self->_spanset->next( $now ) or return undef;
        my $event = $self->_event(-1)->clone( span => $span );
        return $event;
    }
    else {
        return undef;
    }
}

__PACKAGE__->meta->make_immutable;
1;
