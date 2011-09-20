package Upset::Schema::Job;
use Moose -traits => ['MooseX::MetaDescription::Meta::Trait'];
use namespace::autoclean;

use MooseX::Types::Moose ':all';
use Upset::Schema::Types ':all';
use DateTime;

our $VERSION = "0.01";

__PACKAGE__->meta->description->{attributes} = { id => 'jobs', class => 'formfu' };

has 'title' => (
    traits      => ['MooseX::MetaDescription::Meta::Trait'],
    is          => 'ro',
    isa         => Str,
    required    => 1,
    description => { label => 'Title or Position', size => 35 },
);

has 'description' => (
    traits   => ['MooseX::MetaDescription::Meta::Trait'],
    is       => 'ro',
    isa      => Str,
    required => 1,
    description => { label => "Description", size => 35 },
);

has ['long_description', 'requirements'] => (
    traits      => ['MooseX::MetaDescription::Meta::Trait'],
    is          => 'ro',
    isa         => Str,
    required    => 1,
    description => { type => 'Textarea', rows => 8, cols => 40},
);

has 'contact' => (
    traits   => ['MooseX::MetaDescription::Meta::Trait'],
    is       => 'ro',
    isa      => Str,
    required => 1,
    description => { label => 'Contact Person', size => 35},
);

has 'contact_phone' => (
    traits      => ['MooseX::MetaDescription::Meta::Trait'],
    is          => 'ro',
    isa         => Str,
    description => { label => 'Contact Number', size => 35},
);

has 'contact_email' => (
    traits      => ['MooseX::MetaDescription::Meta::Trait'],
    is          => 'ro',
    isa         => Str,
    required    => 1,
    description => { constraints => ['Email'], label => 'Email Address', size => 35 },
);

has 'approved' => (
    is      => 'rw',
    isa     => Bool,
    default => 0,
);

has 'timestamp' => (
    is      => 'ro',
    isa     => 'DateTime',
    default => sub { DateTime->now },
    handles => [qw[ ymd ]],
);

__PACKAGE__->meta->make_immutable;
1;
