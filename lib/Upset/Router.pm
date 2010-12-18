package Upset::Router;
use Moose;
use namespace::autoclean;

extends 'Path::Router';

sub establish_routes {
    my ($self, $c) = @_;

    $self->add_route('/',
        target   => $c->resolve(type => 'Upset::Adapter::Template'),
    );
    $self->add_route('/page/:page',
        target => $c->resolve(type => 'Upset::Adapter::Template'),
    );
}

__PACKAGE__->meta->make_immutable;
1;
