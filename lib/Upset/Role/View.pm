package Upset::Role::View;
use Moose::Role;
use namespace::autoclean;

use Carp;
use MooseX::Types::Moose ':all';
use MooseX::Params::Validate;

requires 'render';

around 'render' => sub {
    my $method = shift;
    my $self   = shift;
    my ($req, $vars) = pos_validated_list(
        \@_,
        { isa => 'Plack::Request' },
        { isa => HashRef },
    );
    my $resp = $self->$method($req, $vars);
    croak "render() must return a response!" unless $resp->isa('Plack::Response');

    return $resp;
};

1;
