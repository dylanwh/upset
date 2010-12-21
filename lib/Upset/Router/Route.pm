package Upset::Router::Route;
use Moose;
use namespace::autoclean;

extends 'Path::Router::Route';

has 'name' => (
    is        => 'ro',
    isa       => 'Str',
    lazy_build => 1,
);

sub _build_name {
    my ($self) = @_;
    return $self->target->name;
}

__PACKAGE__->meta->make_immutable;
1;

