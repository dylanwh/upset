package Upset::Schema::Schedule;
use Moose;
use namespace::autoclean;

use MooseX::Params::Validate;
use Upset::Schema::Schedule::Bucket;
use Upset::Schema::Schedule::Event;

with 'MooseX::Clone';

has 'note' => (
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_note',
    clearer   => 'clear_note',
);

has '_buckets' => (
    traits   => [ 'Hash', 'Clone' ],
    is       => 'ro',
    isa      => 'HashRef[Upset::Schema::Schedule::Bucket]',
    init_arg => 'buckets',
    default  => sub { +{} },
    handles  => {
        bucket     => 'accessor',
        has_bucket => 'exists',
        buckets    => 'values',
    },
);

sub add_event {
    my $self = shift;
    my ($event) = pos_validated_list(\@_, 
        { isa => 'Upset::Schema::Schedule::Event' }
    );

    my $name = $event->name;

    if ($self->has_bucket($name)) {
        $self->bucket($name)->add_event($event);
    }
    else {
        $self->bucket($name => Upset::Schema::Schedule::Bucket->new(events => [ $event ]));
    }
}

sub next_events {
    my $self = shift;
    my ($now) = pos_validated_list(\@_, { isa => 'DateTime' });

    return sort { $a->compare($b)      }
           grep { defined              }
           map  { $_->next_event($now) }
           $self->buckets;
}

sub all_events {
    my $self = shift;

    return sort { $a->compare($b) }
           map     { $_->events } 
           $self->buckets;
}


__PACKAGE__->meta->make_immutable;
1;

