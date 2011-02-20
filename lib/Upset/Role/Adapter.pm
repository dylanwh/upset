package Upset::Role::Adapter;
use Moose::Role;
use namespace::autoclean;

requires '_build_name';

has 'name' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

sub call {
    my $self   = shift;
    my $req    = Upset::Request->new(shift);
    my $method = $req->action ? $req->method . '_' . $req->action : $req->method;

    return $req->new_response(405)->finalize unless $self->can($method);
    my $resp = $self->$method($req, $req->arguments);

    return $resp->finalize;
}

1;
