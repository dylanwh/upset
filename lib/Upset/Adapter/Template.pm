package Upset::Adapter::Template;
use Moose;
use namespace::autoclean;

extends 'Upset::Adapter';
with 'Upset::Role::Adapter::TemplateView';

has 'default_file' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'index.html',
);

sub GET {
    my ($self, $req, $file) = @_;
    $file //= $self->default_file;

    $file =~ s/\.html$/.tt/;
    return $self->render( $req, { file => $file });
}

__PACKAGE__->meta->make_immutable;
1;

