package Upset::Adapter::User;
use Moose;
use namespace::autoclean;

extends 'Upset::Adapter';
with (
    'Upset::Role::Adapter::Transactional',
    'Upset::Role::Adapter::TemplateView',
);

sub GET_login {
    my ($self, $req) = @_;
    $self->render($req => { file => 'user/login.tt' });
}

__PACKAGE__->meta->make_immutable;
1;
