package Upset::Adapter::Template;
use Moose;
use namespace::autoclean;

extends 'Upset::Adapter';

has 'view' => (
    is       => 'ro',
    isa      => 'Upset::View::Template',
    required => 1,
);

has 'default_file' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'index.html',
);

sub GET {
    my ($self, $req, $file) = @_;
    $file //= $self->default_file;

    $file =~ s/\.html$/.tt/;
    return $self->view->render( $req, { file => $file });
}

__PACKAGE__->meta->make_immutable;
1;

