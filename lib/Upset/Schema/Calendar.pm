package Upset::Schema::Calendar;
use Moose;
use namespace::autoclean;

use MooesX::Types::Moose ':all';
use Upset::Schema::Types ':all';

with 'MooseX::Clone';

has '_schedules' => (
    traits  => [ 'Array', 'Clone' ],
    is      => 'ro',
    isa     => ArrayRef[Schedule],
    default => sub { +[] },
);



__PACKAGE__->meta->make_immutable;
1;
