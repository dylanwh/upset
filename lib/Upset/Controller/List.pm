package Upset::Controller::List;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Upset::Controller::List in List.');
}


__PACKAGE__->meta->make_immutable;

