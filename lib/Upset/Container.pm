package Upset::Container;
use Moose;
use namespace::autoclean;

use Upset::View::Template;
use Upset::Adapter::Template;

use Bread::Board;
use Bread::Board::LifeCycle::Singleton::WithParameters;

extends 'Bread::Board::Container';

has '+name' => ( default => 'Upset' );

has 'include_path' => (
    is       => 'ro',
    isa      => 'ArrayRef[Str]',
    required => 1,
);

sub BUILD {
    my $self = shift;

    container $self => as {
        service include_path => $self->include_path;
        typemap 'Upset::View::Template' => infer(
            lifecycle    => 'Singleton::WithParameters',
            dependencies => wire_names('include_path'),
        );
        typemap 'Upset::Adapter::Template' => infer(lifecycle => 'Singleton::WithParameters');
    };
}

__PACKAGE__->meta->make_immutable;
1;
