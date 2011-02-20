package Upset::Role::Adapter::TemplateView;
use Moose::Role;
use namespace::autoclean;

use Hash::Merge ();

has 'template_vars' => (
    is         => 'ro',
    isa        => 'HashRef',
    lazy_build => 1,
);

has 'template_view' => (
    is       => 'ro',
    isa      => 'Upset::View::Template',
    required => 1,
);

sub _build_template_vars { +{} }

sub render {
    my ($self, $req, $vars) = @_;

    return $self->template_view->render($req, Hash::Merge::merge($self->template_vars, $vars) );
}

1;
