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

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
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
        has_events    => 'count',
        event         => 'get',
        _first_event   => 'first',
        _sort_events  => [ 'sort_in_place', sub { $_[0]->compare( $_[1] ) } ],
    },
);

sub BUILD { shift->_sort_events }

after 'add_event' => sub { shift->_sort_events };

sub next_event {
    my $self = shift;
    my ($now) = pos_validated_list( \@_, { isa => 'DateTime' } );

    return $self->_first_event( sub { $_->follows($now) } );
}

__PACKAGE__->meta->make_immutable;
1;
