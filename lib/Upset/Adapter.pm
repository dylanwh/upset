package Upset::Adapter;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

use Upset::Request;

extends 'Plack::Component';
with 'Upset::Role::Adapter';

sub _build_name {
    my $self = shift;
    my $name = $self->meta->name;
    my $prefix = __PACKAGE__ . '::';
    if (index($name, $prefix) == 0) {
        $name = substr($name, length($prefix));
    }
    return $name;
}

__PACKAGE__->meta->make_immutable;
1;
