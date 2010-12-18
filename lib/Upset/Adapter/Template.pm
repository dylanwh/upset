package Upset::Adapter::Template;
use Moose;
use namespace::autoclean;

has 'template' => (
    is       => 'ro',
    isa      => 'Upset::View::Template',
    required => 1,
);

has 'default_file' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'index.html',
);

sub execute {
    my ($self, $req, $file) = @_;
    $file //= $self->default_file;

    $file =~ s/\.html$/.tt/;
    return $self->template->render(
        $req->new_response(200),
        { request => $req, file => $file }
    );
}

__PACKAGE__->meta->make_immutable;
1;

