package Upset::Request;
use strictures 1;
use parent 'Plack::Request';

use Carp;

sub match { $_[0]->env->{'plack.router.match'} }
sub has_match { exists $_[0]->env->{'plack.router.match'} }

sub router { $_[0]->env->{'plack.router'} }
sub has_router { exists $_[0]->env->{'plack.router'} }

sub action {
    my ($self) = @_;

    return $self->match->mapping->{action} if $self->has_match;
    return;
}

sub arguments {
    my ($self) = @_;
    
    return unless exists $self->env->{'plack.router.match.args'};
    return @{ $self->env->{'plack.router.match.args'} };
}

sub session {
    my ($self) = @_;

    return $self->env->{'psgix.session'};
}

sub uri_for {
    my ($self, $name, $path, $args) = @_;
    $path ||= {};

    croak "request has no router!" unless $self->has_router;

    my $router = $self->router;
    my $uri    = $self->base;

    $uri->path($router->uri_for($name, %$path));
    $uri->query_form(@$args) if $args;

    return $uri;
}

1;
