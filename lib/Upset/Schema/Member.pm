package Upset::Schema::Member;
use Moose -traits => ['MooseX::MetaDescription::Meta::Trait'];
use namespace::autoclean;

use MooseX::Types::Moose ':all';
use Upset::Schema::Types ':all';
use DateTime;

our $VERSION = "0.01";

with 'KiokuDB::Role::ID';

__PACKAGE__->meta->description->{attributes} = { id => 'members', class => 'formfu' };

has 'name' => (
    traits   => ['MooseX::MetaDescription::Meta::Trait'],
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has 'email' => (
    traits   => ['MooseX::MetaDescription::Meta::Trait'],
    is       => 'ro',
    isa      => Str,
    required => 1,
    description => { constraints => ['Email'] },
);

has 'homepage' => (
    traits      => ['MooseX::MetaDescription::Meta::Trait'],
    is          => 'ro',
    isa         => Str,
    predicate   => 'has_homepage',
    description => {
        constraints => [
            {   
                type   => 'Regex',
                common => [ qw[ URI HTTP ], { -scheme => 'https?' } ],
            }
        ],
    },
);

has 'distribution' => (
    traits    => ['MooseX::MetaDescription::Meta::Trait'],
    is        => 'ro',
    isa       => Distribution,
    predicate => 'has_distribution',
);

has 'meeting_location' => (
    traits    => ['MooseX::MetaDescription::Meta::Trait'],
    is        => 'ro',
    isa       => MeetingLocation,
    predicate => 'has_meeting_location',
);

has 'announcements' => (
    traits      => ['MooseX::MetaDescription::Meta::Trait'],
    is          => 'ro',
    is          => 'ro',
    isa         => Bool,
    default     => 0,
);

has 'mailing_list' => (
    traits      => ['MooseX::MetaDescription::Meta::Trait'],
    is          => 'ro',
    is          => 'ro',
    isa         => Bool,
    default     => 0,
);

has 'comments' => (
    traits      => ['MooseX::MetaDescription::Meta::Trait'],
    is          => 'ro',
    isa         => 'Str',
    predicate   => 'has_comments',
    description => { type => 'Textarea', rows => 5},
);

has 'timestamp' => (
    is      => 'ro',
    isa     => 'DateTime',
    default => sub { DateTime->now },
);

sub kiokudb_object_id {
    my $self = shift;

    return 'member:' . $self->email;
}

__PACKAGE__->meta->make_immutable;
1;
