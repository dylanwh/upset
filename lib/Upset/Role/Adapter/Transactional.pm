package Upset::Role::Adapter::Transactional;
use Moose::Role;
use namespace::autoclean;

requires 'call';

has 'model' => (
    is       => 'ro',
    isa      => 'Upset::Model',
    required => 1,
);

around 'call' => sub {
    my $method = shift;
    my $self   = shift;
    my @args   = @_;
    my $model  = $self->model;
    $model->txn_do( sub { $self->$method(@args) }, scope => 1, );
};




1;
