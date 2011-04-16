package Upset::Router::Route;
use Moose;
use namespace::autoclean;

use MooseX::Types::Moose ':all';
use MooseX::Types::Structured 'Dict';

extends 'Path::Router::Route';

has 'name' => (
    is        => 'ro',
    isa       => 'Str',
    lazy_build => 1,
);

has '+defaults' => (
    isa     => Dict [ action => Str ],
    default => sub { +{ action => 'default' } },
);

sub _build_name {
    my ($self) = @_;
    return $self->target->name;
}

__PACKAGE__->meta->make_immutable;
1;

