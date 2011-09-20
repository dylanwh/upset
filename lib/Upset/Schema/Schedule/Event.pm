package Upset::Schema::Schedule::Event;
use Moose;
use namespace::autoclean;

use MooseX::Params::Validate;
use MooseX::Types::Moose ':all';

use Carp;
use DateTime::Span;

with 'Upset::Schema::Role::ID';

has 'name' => (
    isa      => Str,
    is       => 'ro',
    required => 1,
);

has 'title' => (
    isa       => Str,
    is        => 'ro',
    predicate => 'has_title',
);

has 'topic' => (
    isa       => Str,
    is        => 'ro',
    predicate => 'has_topic',
);

has 'content' => (
    isa       => Str,
    is        => 'ro',
    predicate => 'has_content',
);

has 'location' => (
    isa      => Str,
    is       => 'ro',
    required => 1,
);

has 'span' => (
    isa      => 'DateTime::Span',
    is       => 'ro',
    required => 1,
);

has 'timestamp' => (
    is      => 'ro',
    isa     => 'DateTime',
    default => sub { DateTime->now },
);

sub slot {
    my $self = shift;

    return sprintf "%s/%s-%s", $self->name, $self->span->start, $self->span->end;
}

sub follows {
    my $self = shift;
    my ($date) = pos_validated_list(\@_, { isa => 'DateTime' });

    return $self->span->end > $date;
}

sub compare {
    my $self = shift;
    my ($event) = pos_validated_list(\@_, { isa => __PACKAGE__ });
    
    return $self->span->start->compare($event->span->start);
}

__PACKAGE__->meta->make_immutable;
1;
