package Upset::Router;
use Moose;
use namespace::autoclean;

extends 'Path::Router';

use Upset::Router::Route;

has 'route_map' => (
    traits  => ['Hash'],
    is      => 'ro',
    isa     => 'HashRef[ArrayRef[Upset::Router::Route]]',
    lazy    => 1,
    builder => '_build_route_map',
    clearer => 'clear_route_map',
    handles => { find_routes => 'get' },
);

has '+routes'      => ( isa     => 'ArrayRef[Upset::Router::Route]' );
has '+route_class' => ( default => 'Upset::Router::Route' );

sub _build_route_map {
    my $self = shift;
    my %map;

    for my $route ( @{ $self->routes } ) {
        push @{ $map{ $route->name } }, $route;
    }

    return \%map;
}

after [ 'add_route', 'insert_route' ] => sub {
    my $self   = shift;
    $self->clear_route_map;
};

around 'uri_for' => sub {
    my $method = shift;
    my $self   = shift;
    my $name   = shift;

    my ($slot) = $self->meta->find_attribute_by_name('routes')->slots;
    local $self->{$slot} = $self->find_routes($name) || [];

    return $self->$method(@_);
};

__PACKAGE__->meta->make_immutable;
1;

