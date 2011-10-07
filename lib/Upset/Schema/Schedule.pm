package Upset::Schema::Schedule;
use Moose;
use namespace::autoclean;

use MooseX::Params::Validate;

use Upset::Schema::Schedule::Bucket;
use Upset::Schema::Schedule::Event;

has '_buckets' => (
    traits   => [ 'Hash' ],
    is       => 'ro',
    isa      => 'HashRef[Upset::Schema::Schedule::Bucket]',
    init_arg => 'buckets',
    default  => sub { +{} },
    handles  => {
        bucket     => 'accessor',
        has_bucket => 'exists',
        buckets    => 'values',
        clear      => 'clear',
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
        my $bucket = Upset::Schema::Schedule::Bucket->new( name => $event->name );
        $bucket->add_event($event);
        $self->bucket( $name => $bucket );
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

sub events {
    my $self = shift;

    return sort { $a->compare($b) }
           map  { $_->events } 
           $self->buckets;
}

__PACKAGE__->meta->make_immutable;
1;
