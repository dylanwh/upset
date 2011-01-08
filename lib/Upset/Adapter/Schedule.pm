package Upset::Adapter::Schedule;
use Moose;
use namespace::autoclean;

use Upset::Schema::Schedule;

extends 'Upset::Adapter';

has 'model' => (
    is       => 'ro',
    isa      => 'Upset::Model',
    required => 1,
);

has 'view' => (
    is       => 'ro',
    isa      => 'Upset::View::Template',
    required => 1,
    handles => ['render'],
);

around 'call' => sub {
    my $method = shift;
    my $self   = shift;
    my $scope = $self->model->new_scope;
    $self->$method(@_);
};

# TODO: Cache
sub events {
    my ($self) = @_;

    return [ $self->model->schedule->next_events( DateTime->now ) ];
}

sub GET_list {
    my ($self, $req) = @_;

    return $self->render($req, { file => 'schedule/list.tt', events => $self->events });
}


__PACKAGE__->meta->make_immutable;
1;
