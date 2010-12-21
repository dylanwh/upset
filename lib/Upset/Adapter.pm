package Upset::Adapter;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

use Upset::Request;

extends 'Plack::Component';

has 'name' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

sub _build_name {
    my $self = shift;
    my $name = $self->meta->name;
    my $prefix = __PACKAGE__ . '::';
    if (index($name, $prefix) == 0) {
        $name = substr($name, length($prefix));
    }
    return $name;
}

sub call {
    my $self   = shift;
    my $req    = Upset::Request->new(shift);
    my $method = $req->action ? $req->method . '_' . $req->action : $req->method;

    return $req->new_response(405) unless $self->can($method);
    my $resp = $self->$method($req, $req->arguments);

    return $resp->finalize;
}

1;

__PACKAGE__->meta->make_immutable;
1;
